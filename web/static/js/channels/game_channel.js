/* Game Channel
 * Only sends and receives pings to confirm played
 * all player data is sent via the player channel
 * NOTE: This does not receive the GAME data as its not private
 */

import PlayerChannel from "./player_channel";

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
      console.log(`initialized the Game channel for GameId: ${gameId}`);
      _this.initializePlayerChannel();
    }).receive("error", reason =>
      console.log("join failed")
    )

    App.gameChannel.on("game:other_player_played", function() {
      App.playerChannel.push("player:get_fresh_data", function(resp){
        App.store.dispatch({type: "GAME_DATA_RECEIVED", game: resp})
      }).receive("error", reason =>
        console.log("join failed")
      )
    });

  }

  initializePlayerChannel() {
    new PlayerChannel();
  }

}

export default GameChannel;
