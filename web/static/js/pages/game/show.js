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
import HeaderComponent from "../../components/header_component"
import SideNavComponent from "../../components/side_nav_component"
import PageComponentManager from "../../utils/page_component_manager"

import page from "../page"

class GameShowPage extends page {

  constructor(opts={}) {
    super(opts, "game-show");
  }

  setUpPage() {
    new tournamentChannel();
    new gameChannel();
    new chatChannel();
    new playerChannel();
    this.initializeGameComponent();
    this.initializeLadderComponent();
    this.initializeChipsComponent();
    this.initializeHeaderComponent();
    this.initializeChatComponent();
    this.initializeProfileComponent();
    this.initializeRulesComponent();
    this.initializeSideNavComponent();
    new PageComponentManager().init();
  }

  initializeLadderComponent() {
    ReactDOM.render(<LadderComponent store={App.store} title="Tournament Name" page="Game"/>, document.getElementById('ladder-holder'));
  }

  initializeChipsComponent() {
    ReactDOM.render(<ChipsComponent store={App.store}/>, document.getElementById('chips-holder'));
  }

  initializeHeaderComponent() {
    ReactDOM.render(<HeaderComponent store={App.store}/>, document.getElementById('header-component-holder'));
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
    ReactDOM.render(<SideNavComponent store={App.store} page_name="game-show"/>, document.getElementById('nav-holder'));
  }

}

export default GameShowPage;
