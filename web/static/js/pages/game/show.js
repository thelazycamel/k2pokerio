import React from "react"
import ReactDOM from "react-dom"

import tournamentChannel from "../../channels/tournament_channel"
import chatChannel from "../../channels/chat_channel"
import gameChannel from "../../channels/game_channel"
import playerChannel from "../../channels/player_channel"

import TournamentComponent from "../../components/tournament_component"
import ChatComponent from "../../components/chat_component"
import GameComponent from "../../components/game_component"
import HeaderComponent from "../../components/header_component"

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
    this.initializeHeaderComponent();
    this.initializeChatComponent();
  }

  initializeTournamentComponent() {
    ReactDOM.render(<TournamentComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('tournament-root'));
  }

  initializeHeaderComponent() {
    ReactDOM.render(<HeaderComponent store={App.store}/>, document.getElementById('header-component-holder'));
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('chat-root'));
  }

  initializeGameComponent() {
    ReactDOM.render(<GameComponent store={App.store}/>, document.getElementById('game-root'));
  }

}

export default GameShowPage;
