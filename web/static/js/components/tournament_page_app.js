import React from "react"
import ReactDOM from "react-dom"
import TournamentGraphComponent from "./tournament_graph_component"

class TournamentPageApp extends React.Component {

  tournamentGraph() {
    return (<TournamentGraphComponent page="Tournament"/>)
  }

  render() {
    return (<section id="tournament">
              {this.tournamentGraph()}
            </section>)
  }

}

export default TournamentPageApp;
