import page from "../page"
import tournamentChannel from "../../channels/tournament_channel"
import React from "react"
import ReactDOM from "react-dom"
import TournamentPageApp from "../../components/tournament_page_app"

class TournamentShowPage extends page {

  constructor(opts={}) {
    super(opts, "tournament-show");
  }

  setUpPage() {
    this.currentTournamentChannel = new tournamentChannel(this.socket);
    this.eventListeners();
    this.initializeTournamentComponent();
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

   initializeTournamentComponent() {
     ReactDOM.render(<TournamentPageApp />, document.getElementById('root'));
   }


}

export default TournamentShowPage;
