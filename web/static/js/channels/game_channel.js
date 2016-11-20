class GameChannel {

  constructor(){
    let element = document.getElementById("root");
    let gameId = element.getAttribute("data-game");
    if(!element || !gameId) { return; }
    this.joinGameChannel(gameId, element);
  }

  joinGameChannel(gameId, element) {
    App.gameChannel = App.socket.channel("game:" + gameId);
    let _this = this;
    App.gameChannel.join().receive("ok", function(resp) {
      App.gameChannel.push("game:refresh_data");
    }).receive("error", reason =>
      console.log("join failed")
    )

    App.gameChannel.on("game:new_game_data", function(resp) {
      App.store.dispatch({type: "GAME_DATA_RECEIVED", game: resp})
    });

    App.gameChannel.on("game:new_game", function(resp) {
      console.log("going to a new game ", resp);
      window.location = "/games/" + resp.game_id;
    });

  }

}

export default GameChannel;
