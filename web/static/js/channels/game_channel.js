class GameChannel {

  constructor(){
    $.when(this.getGameId()).done( (data, status, jqXHR) => {
      this.joinGameChannel(data);
    });
  }

  joinGameChannel(data) {
    if(data.game_id) {
      App.gameChannel = App.socket.channel("game:" + data.game_id);
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

  getGameId() {
    return $.ajax({
      url: "/games/join",
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', $("meta[name='csrf_token']").attr("content"))}
    });
  }

}

export default GameChannel;
