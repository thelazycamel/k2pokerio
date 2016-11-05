import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import TournamentGraphComponent from "../components/tournament_graph_component"
import GameComponent from "../components/game_component"

class GamePageApp extends React.Component {

  tournamentGraph() {
    return (<TournamentGraphComponent tournament={this.props.tournament} page="Game"/>)
  }

  game() {
    return (<GameComponent game={this.props.game}/>)
  }

  render() {
    return (<Provider store={this.props.store}>
              <div id="game-page-wrapper">
                <section id="game-section" >{this.game()}</section>
                <section id="tournament-section" >{this.tournamentGraph()}</section>
              </div>
            </Provider>)
  }
}

export default GamePageApp;
