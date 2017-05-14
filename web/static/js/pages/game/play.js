import React from "react"
import ReactDOM from "react-dom"

import tournamentChannel from "../../channels/tournament_channel"
import chatChannel from "../../channels/chat_channel"
import gameChannel from "../../channels/game_channel"
import playerChannel from "../../channels/player_channel"

import LadderComponent from "../../components/ladder_component"
import ChipsComponent from "../../components/chips_component"
import ChatComponent from "../../components/chat_component"
import GameComponent from "../../components/game_component"
import ProfileComponent from "../../components/profile_component"
import RulesComponent from "../../components/rules_component"
import HeaderNavComponent from "../../components/header_nav_component"
import SideNavComponent from "../../components/side_nav_component"
import BotRequestComponent from "../../components/bot_request_component"
import PageComponentManager from "../../utils/page_component_manager"

import page from "../page"

class GamePlayPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.connectSocket();
    new tournamentChannel();
    new chatChannel();
    new playerChannel();
    this.loadNewGame();
    this.initializeComponents();
    App.pageComponentManager = new PageComponentManager();
    App.pageComponentManager.init();
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
    this.initializeBotRequestComponent();
  }

  setBotRequest() {
    this.botPopupRequest = setTimeout(function(){
      App.store.dispatch({type: "PAGE:SHOW_BOT_POPUP"});
    },5000)
  }

  clearBotRequest() {
    clearTimeout(this.botPopupRequest);
  }

  loadNewGame() {
    new gameChannel();
  }

  initializeLadderComponent() {
    ReactDOM.render(<LadderComponent store={App.store} title="Tournament Name" page="Game"/>, document.getElementById('ladder-holder'));
  }

  initializeChipsComponent() {
    ReactDOM.render(<ChipsComponent store={App.store}/>, document.getElementById('chips-holder'));
  }

  initializeHeaderNavComponent() {
    ReactDOM.render(<HeaderNavComponent store={App.store}/>, document.getElementById('header-nav-component-holder'));
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('chat-holder'));
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

  initializeBotRequestComponent() {
    ReactDOM.render(<BotRequestComponent store={App.store}/>, document.getElementById('bot-request-holder'));
  }

}

export default GamePlayPage;
