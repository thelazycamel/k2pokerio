class TournamentChannel {

  constructor(){
    let element = document.getElementById("ladder-holder");
    let tournamentId = element.getAttribute("data-tournament");
    if(!element || !tournamentId) { return; }
    this.joinTournamentChannel(tournamentId, element);
  }

  joinTournamentChannel(tournamentId, element) {
    console.log(App.socket);
    App.tournamentChannel = App.socket.channel("tournament:" + tournamentId);
    App.tournamentChannel.join().receive("ok", function(resp){
      console.log(`initialized the Tournament channel for Tournament: ${tournamentId}`);
    }).receive("error", reason =>
      console.log("join failed")
    )

    App.tournamentChannel.on("ping", ({count}) =>
      console.log("PING: ", count)
    )

  }

};

export default TournamentChannel;
