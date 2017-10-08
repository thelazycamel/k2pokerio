class GameChannel {

  constructor(game_id){
    this.joinGameChannel(game_id);
  }

  joinGameChannel(game_id) {
    if(game_id) {
      App.gameChannel = App.socket.channel("game:" + game_id);
      App.gameChannel.join().receive("ok", function(resp) {
        App.gameChannel.push("game:refresh_data");
        App.services.opponent_profile.call();
        App.settings["game_id"] = game_id;
      }).receive("error", reason =>
        console.log("join failed")
      )

      App.gameChannel.on("game:new_game_data", function(resp) {
        App.store.dispatch({type: "GAME:DATA_RECEIVED", game: resp});
      });
    } else {
      window.location = "/";
    }
  }


}

export default GameChannel;
