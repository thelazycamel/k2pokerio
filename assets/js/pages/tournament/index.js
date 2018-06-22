import React from "react"
import ReactDOM from "react-dom"
import chatChannel from "../../channels/chat_channel"
import ChatComponent from "../../components/chat_component"
import TournamentIndexComponent from "../../components/pages/tournament_index_component"

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
    App.services.tournaments.for_user();
  }

  getData(name){
    let element = this.wrapperElement();
    return element.dataset[name];
  }

  wrapperElement(){
    return document.getElementById("tournament-index-wrapper")
  }

  initializeTournamentIndexComponent() {
    ReactDOM.render(<TournamentIndexComponent store={App.store} username={this.getData("username")} profile_image={this.getData("profileImage")} />, this.wrapperElement());
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} />, document.getElementById('chat-holder'));
  }

}

export default TournamentIndexPage;
