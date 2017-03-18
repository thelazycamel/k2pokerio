import React from "react"
import ReactDOM from "react-dom"

import tournamentChannel from "../../channels/tournament_channel"
import chatChannel from "../../channels/chat_channel"
import gameChannel from "../../channels/game_channel"
import playerChannel from "../../channels/player_channel"

import TournamentComponent from "../../components/tournament_component"
import ChipsComponent from "../../components/chips_component"
import ChatComponent from "../../components/chat_component"
import GameComponent from "../../components/game_component"
import HeaderComponent from "../../components/header_component"
import SideNavComponent from "../../components/side_nav_component"

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
    this.initializeTournamentComponent();
    this.initializeChipsComponent();
    this.initializeHeaderComponent();
    this.initializeChatComponent();
    this.initializeSideNavComponent();
  }

  initializeTournamentComponent() {
    ReactDOM.render(<TournamentComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('tournament-holder'));
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

  initializeSideNavComponent() {
    ReactDOM.render(<SideNavComponent store={App.store} page_name="game-show"/>, document.getElementById('nav-holder'));
  }

}

export default GameShowPage;
