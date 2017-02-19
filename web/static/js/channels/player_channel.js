class PlayerChannel {

  constructor(){
    this.joinPlayerChannel();
  }

  joinPlayerChannel() {

    App.playerChannel = App.socket.channel("player:" + window.userToken);

    App.playerChannel.join().receive("ok", function(resp) {
      App.playerChannel.push("player:get_current_score");
    }).receive("error", reason =>
      console.log("join failed")
    )

    App.playerChannel.on("player:updated_score", function(resp) {
      App.store.dispatch({type: "PLAYER:UPDATE_PLAYER_SCORE", score: resp})
    });

  }

}

export default PlayerChannel;
