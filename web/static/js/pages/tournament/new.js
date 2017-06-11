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

  element() {
    return document.getElementById("new-tournament");
  }

  friends() {
    return window.PageData.friends;
  }

  initializeNewTournamentComponent() {
    ReactDOM.render(<NewTournamentComponent friends={this.friends()}/>, this.element());
  }

}

export default TournamentIndexPage;
