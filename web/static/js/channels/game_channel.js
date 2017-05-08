class GameChannel {

  constructor(){
    let _this = this;
    $.ajax({
      url: "/games/join",
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', $("meta[name='csrf_token']").attr("content"))}
    }).done(function(data){
      _this.joinGameChannel(data.game_id);
    }).fail(function(){
      window.location = "/";
    });
  }

  joinGameChannel(game_id) {
    if(game_id) {
      App.gameChannel = App.socket.channel("game:" + game_id);
      App.gameChannel.join().receive("ok", function(resp) {
        App.gameChannel.push("game:refresh_data");
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
