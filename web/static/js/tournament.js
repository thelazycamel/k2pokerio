/* TODO:
 * Seperate tournament page concerns from tournament socket channel concerns
 * we will be joining the socket from different pages
 * and tournament page will need its own page events handlers
 */
import {Socket} from "phoenix";

class Tournament {

  constructor(socket){
    let element = document.getElementById("tournament-graph");
    let tournamentId = element.getAttribute("data-tournament");
    if(!element || !tournamentId) { return; }
    this.joinTournamentChannel(socket, tournamentId, element);
    this.joinChatChannel(socket, tournamentId);
    this.setupEventListeners(tournamentId);
  }

  setupEventListeners(tournamentId){
    let playButton = document.getElementById("play-tournament");
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

  joinTournamentChannel(socket, tournamentId, element) {
    let tournamentChannel = socket.channel("tournament:" + tournamentId);
    tournamentChannel.join().receive("ok", resp =>
      console.log(`initialized the Tournament channel for Tournament: ${tournamentId}`)
    ).receive("error", reason =>
      console.log("join failed")
    )

    tournamentChannel.on("ping", ({count}) =>
      console.log("PING: ", count)
    )

  }

  joinChatChannel(socket, tournamentId) {
    let chatChannel = socket.channel("chat:" + tournamentId);

    chatChannel.join().receive("ok", resp =>
      console.log(`initialized the Chat channel for Tournament: ${tournamentId}`)
    ).receive("error", reason =>
      console.log("join failed")
    )
  }

};

export default Tournament;
