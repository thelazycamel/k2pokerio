import page from "../page";
import tournamentChannel from "../../channels/tournament_channel";

class TournamentShowPage extends page {

  constructor(opts={}) {
    super(opts, "tournament-show");
  }

  setUpPage() {
    this.currentTournamentChannel = new tournamentChannel(this.socket);
    this.eventListeners();
  }

  eventListeners(){
    let playButton = document.getElementById("play-tournament");
    let tournamentId = playButton.getAttribute("data-tournament");
    if(playButton){
      playButton.addEventListener("click", function(){
        let currentScore = this.getAttribute("data-score");
        $.ajax({
          url: "/games/join",
          method: "POST",
          dataType: "json",
          beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', $("meta[name='csrf_token']").attr("content"))},
          data: {tournamentId: tournamentId}
        }).done(function(data){
          window.location = `/games/${data.game_id}`;
        }).fail(function(data){
          alert("failed to join")
          console.log(data);
        });
      });
    }
  }

}

export default TournamentShowPage;
