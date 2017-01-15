import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import TournamentGraphComponent from "../components/tournament_graph_component"

class TournamentPageApp extends React.Component {

  tournamentGraph() {
    return (<TournamentGraphComponent tournament={this.props.tournament} title="TODO: pass tournament name" page="Tournament"/>)
  }

  render() {
    return (<Provider store={this.props.store}>
              <section id="tournament">
                {this.tournamentGraph()}
              </section>
            </Provider>)
  }

}


export default TournamentPageApp;
