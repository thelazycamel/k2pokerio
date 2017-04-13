class GameChannel {

  constructor(){
    let _this = this;
    $.when(this.getGameId()).then(function() {
      _this.joinGameChannel();
      _this.setEventListeners()
    });
  }

  getGameId() {
    $.ajax({
      url: "/games/join",
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', $("meta[name='csrf_token']").attr("content"))}
    }).done(function(data){
      console.log("joined response",data);
      App.gameID = data.game_id;
    }).fail(function(data){
      alert("failed to join")
      console.log(data);
    });
  }

  joinGameChannel() {
    App.gameChannel = App.socket.channel("game:" + App.gameID);
    App.gameChannel.join().receive("ok", function(resp) {
      App.gameChannel.push("game:refresh_data");
    }).receive("error", reason =>
      console.log("join failed")
    )
  }

  setEventListeners() {
    App.gameChannel.on("game:new_game_data", function(resp) {
      console.log("****** new response ******");
      console.log(App.gameID);
      console.log(resp);
      App.store.dispatch({type: "GAME:DATA_RECEIVED", game: resp})
    });

    App.gameChannel.onClose(function() {
      alert("closing");
    });

    App.gameChannel.on("game:new_game", function(resp) {
      App.gameChannel.leave().receive("ok", ()=> {
        alert("I have left the channel");
        delete App.gameChannel
        App.gameChannel = new GameChannel();
      });
    });

  }

}

export default GameChannel;
