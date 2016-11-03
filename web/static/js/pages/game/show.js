import React from "react"
import ReactDOM from "react-dom"

import page from "../page"
import tournamentChannel from "../../channels/tournament_channel"
import gameChannel from "../../channels/game_channel"
import GamePageApp from "../../components/game_page_app"

class GameShowPage extends page {

  constructor(opts={}) {
    super(opts, "game-show");
  }

  setUpPage() {
    this.currentTournamentChannel = new tournamentChannel(this.socket);
    this.currentGameChannel = new gameChannel(this.socket);
    this.initializeGameComponent();
  }

  initializeGameComponent() {
    ReactDOM.render(<GamePageApp />, document.getElementById('root'));
  }

}

export default GameShowPage;
