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

    App.tournamentChannel.on("tournament:update_count", (resp) =>
      App.store.dispatch({type: "TOURNAMENT:UPDATE_COUNT", player_count: resp.player_count})
    )

  }

};

export default TournamentChannel;
