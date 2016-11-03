import {Socket} from "phoenix";

class TournamentChannel {

  constructor(socket){
    let element = document.getElementById("tournament-graph");
    let tournamentId = element.getAttribute("data-tournament");
    if(!element || !tournamentId) { return; }
    this.joinTournamentChannel(socket, tournamentId, element);
    this.joinChatChannel(socket, tournamentId);
  }

  joinTournamentChannel(socket, tournamentId, element) {
    let currentTournamentChannel = socket.channel("tournament:" + tournamentId);
    currentTournamentChannel.join().receive("ok", resp =>
      console.log(`initialized the Tournament channel for Tournament: ${tournamentId}`)
    ).receive("error", reason =>
      console.log("join failed")
    )

    currentTournamentChannel.on("ping", ({count}) =>
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

export default TournamentChannel;
