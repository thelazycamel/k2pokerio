import React from "react"
import ReactDOM from "react-dom"
import chatChannel from "../../channels/chat_channel"
import ChatComponent from "../../components/chat_component"
import TournamentIndexComponent from "../../components/tournament_index_component"

import page from "../page"

class TournamentIndexPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.connectSocket();
    new chatChannel();
    this.initializeTournamentIndexComponent();
    this.initializeChatComponent();
    this.getTournaments();
  }

  getTournaments() {
    App.services.get_tournaments_for_user_service.call();
  }

  initializeTournamentIndexComponent() {
    ReactDOM.render(<TournamentIndexComponent store={App.store} />, document.getElementById("tournament-index-wrapper"));
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} />, document.getElementById('chat-holder'));
  }

}

export default TournamentIndexPage;
