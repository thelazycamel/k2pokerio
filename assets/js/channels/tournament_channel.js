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

    App.tournamentChannel.on("tournament:loser", (data) =>
      App.store.dispatch({type: "TOURNAMENT:LOSER", data: data})
    )

    App.tournamentChannel.on("tournament:winner", (data) =>
      App.store.dispatch({type: "TOURNAMENT:WINNER", data: data})
    )
  }

};

export default TournamentChannel;
