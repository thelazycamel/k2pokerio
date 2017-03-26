import page from "../page"
import React from "react"
import ReactDOM from "react-dom"
import tournamentChannel from "../../channels/tournament_channel"
import chatChannel from "../../channels/chat_channel"
import LadderComponent from "../../components/ladder_component"
import ChatComponent from "../../components/chat_component"
import playerChannel from "../../channels/player_channel"

class TournamentShowPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.tournamentId = document.getElementById("ladder-holder").getAttribute("data-tournament");
    new tournamentChannel();
    new chatChannel(this.tournamentId);
    new playerChannel();
    this.eventListeners();
    this.initializeLadderComponent();
    this.initializeChatComponent();
  }

  eventListeners(){
    let playButton = document.getElementById("play-tournament");
    let _this = this;
    if(playButton){
      playButton.addEventListener("click", function(){
        _this.playButtonClicked();
      });
    }
  }

  playButtonClicked() {
    $.ajax({
      url: "/games/join",
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', $("meta[name='csrf_token']").attr("content"))}
    }).done(function(data){
      window.location = `/games/${data.game_id}`;
    }).fail(function(data){
      alert("failed to join")
      console.log(data);
    });
   }

  initializeLadderComponent() {
    ReactDOM.render(<LadderComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('ladder-holder'));
  }

  initializeChatComponent() {
    ReactDOM.render(<ChatComponent store={App.store} title="Tournament Name" page="Tournament"/>, document.getElementById('chat-holder'));
  }

}

export default TournamentShowPage;
