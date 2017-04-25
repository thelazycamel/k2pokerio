class TournamentChannel {

  constructor(){
    this.joinTournamentChannel();
  }

  joinTournamentChannel() {
    let tournamentId = App.settings.tournament_id;
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
