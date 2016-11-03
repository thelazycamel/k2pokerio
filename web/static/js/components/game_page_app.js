import React from "react"
import ReactDOM from "react-dom"
import TournamentGraphComponent from "./tournament_graph_component"

class GamePageApp extends React.Component {

  tournamentGraph() {
    return (<TournamentGraphComponent page="Game"/>)
  }

  render() {
    return (<div id="game-page-wrapper">
              <section id="game"></section>
              <section id="tournament">{this.tournamentGraph()}</section>
            </div>)
  }
}

export default GamePageApp;
