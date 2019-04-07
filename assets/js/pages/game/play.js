import React from "react"
import ReactDOM from "react-dom"

import tournamentChannel from "js/channels/tournament_channel"
import chatChannel from "js/channels/chat_channel"

import LadderComponent from "js/components/pages/game/ladder_component"
import ChipsComponent from "js/components/pages/game/chips_component"
import ChatComponent from "js/components/chat_component"
import GameComponent from "js/components/game_component"
import ProfileComponent from "js/components/pages/game/profile_component"
import RulesComponent from "js/components/pages/game/rules_component"
import HeaderNavComponent from "js/components/header_nav_component"
import SideNavComponent from "js/components/pages/game/side_nav_component"
import PageComponentManager from "js/utils/page_component_manager"
import TournamentWinnerPopup from "js/components/popups/tournament_winner_popup"
import TournamentLoserPopup from "js/components/popups/tournament_loser_popup"

import page from "../page"

class GamePlayPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.countDown = 10;
    this.countDownTimer = () => null;
    this.connectSocket();
    new tournamentChannel();
    new chatChannel();
    this.initializeComponents();
    App.pageComponentManager = new PageComponentManager();
    App.pageComponentManager.init();
    this.loadNewGame();
    App.services.tournaments.get_scores();
  }

  initializeComponents() {
    this.initializeGameComponent();
    this.initializeLadderComponent();
    this.initializeChipsComponent();
    this.initializeHeaderNavComponent();
    this.initializeChatComponent();
    this.initializeProfileComponent();
    this.initializeRulesComponent();
    this.initializeSideNavComponent();
  }

  stopCountDown(){
    App.store.dispatch({type: "GAME:COUNTDOWN", countDown: null});
    this.countDown = 10;
    clearInterval(this.countDownTimer);
  }

  dropOneSecond() {
    this.countDown = (this.countDown <= 0) ? 0 : this.countDown -1;
    App.store.dispatch({type: "GAME:COUNTDOWN", countDown: this.countDown});
  }

  startCountDown(){
    const { opponent } = App.store.getState().opponent_profile;
    if(this.countDown != 10 || opponent == "bot" ) {
      return new Promise((resolve, reject) => {
        reject(false);
      });
    } else {
      clearInterval(this.countDownTimer);
      this.countDownTimer = setInterval(this.dropOneSecond.bind(this), 1000);
      return new Promise((resolve, reject) => {
        resolve(this.countDown);
      });
    }
  };

  setWaitingPing() {
    this.waitingPing = setTimeout(function(){
      App.store.dispatch({type: "GAME:WAITING_PING"});
    }, 11000);
  }

  clearWaitingPing() {
    clearTimeout(this.waitingPing);
  }

  setBotRequest() {
    if(App.settings.bots == "true"){
      this.botPopupRequest = setTimeout(function(){
        App.store.dispatch({type: "GAME:SHOW_BOT_BUTTON"});
      },3000);
    }
  }

  //Fixes an issue where 2 players can create a new game in a duel
  //at exactly the same time, this pings the server to check for 2 open
  //games and will delete one then reload the game
  duelFix() {
    if(App.settings.tournament_type == "duel") {
      let rand = Math.floor((Math.random() *10000) + 1000);
      let _this = this;
      this.duelFixTimeout = setTimeout(function(){
        console.log("sending duelfix request")
        App.services.games.duelFix().then(data => {
          console.log(data);
          console.log(data.message);
          if(data.message == "updated") {
            _this.loadNewGame();
          }
        })
      },rand);
    }
  }

  clearBotRequest() {
    clearTimeout(this.botPopupRequest);
  }

  loadNewGame() {
    App.services.games.join();
  }

  maxScore() {
    let element = document.getElementById("ladder-holder");
    return parseInt(element.dataset.maxScore, 10);
  }

  showTournamentLoserPopup(action) {
    ReactDOM.render(<TournamentLoserPopup username={action.username} type={action.type}/>, document.getElementById('popup-holder'));
  }

  showTournamentWinnerPopup(action) {
    ReactDOM.render(<TournamentWinnerPopup username={action.username} type={action.type}/>, document.getElementById('popup-holder'));
  }

  initializeLadderComponent() {
    ReactDOM.render(<LadderComponent store={App.store} maxScore={this.maxScore()} page="Game"/>, document.getElementById('ladder-holder'));
  }

  initializeChipsComponent() {
    ReactDOM.render(<ChipsComponent store={App.store}/>, document.getElementById('chips-holder'));
  }

  initializeHeaderNavComponent() {
    ReactDOM.render(<HeaderNavComponent store={App.store}/>, document.getElementById('header-nav-component-holder'));
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} />, document.getElementById('chat-holder'));
  }

  initializeGameComponent() {
    ReactDOM.render(<GameComponent store={App.store}/>, document.getElementById('game-holder'));
  }

  initializeProfileComponent() {
    ReactDOM.render(<ProfileComponent store={App.store}/>, document.getElementById('profile-holder'));
  }

  initializeRulesComponent() {
    ReactDOM.render(<RulesComponent store={App.store} />, document.getElementById('rules-holder'));
  }

  initializeSideNavComponent() {
    ReactDOM.render(<SideNavComponent store={App.store} />, document.getElementById('nav-holder'));
  }

}

export default GamePlayPage;
