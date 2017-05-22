class TournamentChannel {

  constructor(){
    this.joinTournamentChannel();
  }

  joinTournamentChannel() {
    let tournamentId = App.settings.tournament_id;
    App.tournamentChannel = App.socket.channel("tournament:" + tournamentId);
    App.tournamentChannel.join().receive("ok", function(resp){
    }).receive("error", reason =>
      console.log("join failed")
    )

    App.tournamentChannel.on("tournament:update", (data) =>
      App.store.dispatch({type: "TOURNAMENT:UPDATE", data: data})
    )

  }

};

export default TournamentChannel;
