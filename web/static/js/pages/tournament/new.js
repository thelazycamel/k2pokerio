import React from "react"
import ReactDOM from "react-dom"
import page from "../page"
import NewTournamentComponent from "../../components/new_tournament_component"

class TournamentIndexPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.initializeNewTournamentComponent();
  }

  initializeNewTournamentComponent() {
    ReactDOM.render(<NewTournamentComponent />, document.getElementById('new-tournament'));
  }

}

export default TournamentIndexPage;
