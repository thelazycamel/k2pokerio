import React from "react"
import ReactDOM from "react-dom"

import tournamentChannel from "../../channels/tournament_channel"
import chatChannel from "../../channels/chat_channel"

import LadderComponent from "../../components/pages/game/ladder_component"
import ChipsComponent from "../../components/pages/game/chips_component"
import ChatComponent from "../../components/chat_component"
import GameComponent from "../../components/game_component"
import ProfileComponent from "../../components/pages/game/profile_component"
import RulesComponent from "../../components/pages/game/rules_component"
import HeaderNavComponent from "../../components/header_nav_component"
import SideNavComponent from "../../components/pages/game/side_nav_component"
import PageComponentManager from "../../utils/page_component_manager"
import TournamentWinnerPopup from "../../components/popups/tournament_winner_popup"
import TournamentLoserPopup from "../../components/popups/tournament_loser_popup"

import page from "../page"

class GamePlayPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
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
    ReactDOM.render(<RulesComponent store={App.store}/>, document.getElementById('rules-holder'));
  }

  initializeSideNavComponent() {
    ReactDOM.render(<SideNavComponent store={App.store} />, document.getElementById('nav-holder'));
  }

}

export default GamePlayPage;
