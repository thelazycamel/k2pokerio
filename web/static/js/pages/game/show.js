import React from "react"
import ReactDOM from "react-dom"

import tournamentChannel from "../../channels/tournament_channel"
import chatChannel from "../../channels/chat_channel"
import gameChannel from "../../channels/game_channel"

import TournamentGraphComponent from "../../components/tournament_graph_component"
import ChatComponent from "../../components/chat_component"
import GameComponent from "../../components/game_component"

import page from "../page"

class GameShowPage extends page {

  constructor(opts={}) {
    super(opts, "game-show");
  }

  setUpPage() {
    new tournamentChannel(this.socket);
    new gameChannel(this.socket);
    new chatChannel(this.socket);
    this.initializeGameComponent();
    this.initializeTournamentComponent();
    this.initializeChatComponent();
  }

  initializeTournamentComponent() {
    ReactDOM.render(<TournamentGraphComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('tournament-root'));
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('chat-root'));
  }

  initializeGameComponent() {
    ReactDOM.render(<GameComponent store={App.store}/>, document.getElementById('game-root'));
  }

}

export default GameShowPage;
