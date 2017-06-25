import React from "react"
import ReactDOM from "react-dom"
import page from "../page"
import TournamentIndexComponent from "../../components/tournament_index_component"

class TournamentIndexPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.initializeTournamentIndexComponent();
    this.getTournaments();
  }

  getTournaments() {
    App.services.get_tournaments_for_user_service.call();
  }

  initializeTournamentIndexComponent() {
    ReactDOM.render(<TournamentIndexComponent store={App.store} />, document.getElementById("tournament-index-wrapper"));
  }

}

export default TournamentIndexPage;
