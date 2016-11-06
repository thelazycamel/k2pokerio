import React from "react"
import ReactDOM from "react-dom"

import tournamentChannel from "../../channels/tournament_channel"
import gameChannel from "../../channels/game_channel"
import GamePageApp from "../../apps/game_page_app"
import page from "../page"

class GameShowPage extends page {

  constructor(opts={}) {
    super(opts, "game-show");
  }

  setUpPage() {
    new tournamentChannel(this.socket);
    new gameChannel(this.socket);
    this.initializeGameComponent();
  }

  initializeGameComponent() {
    ReactDOM.render(<GamePageApp store={App.store}/>, document.getElementById('root'));
  }

}

export default GameShowPage;
