import React from "react"
import ReactDOM from "react-dom"
import chatChannel from "../../channels/chat_channel"
import ChatComponent from "../../components/chat_component"
import TournamentIndexComponent from "../../components/pages/tournament_index_component"

import page from "../page"

class TournamentShowPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.connectSocket();
    new chatChannel();
    this.initializeChatComponent();
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} />, document.getElementById('chat-holder'));
  }

}

export default TournamentShowPage;
