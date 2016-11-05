/* Game Channel
 * Only sends and receives pings to confirm played
 * all player data is sent via the player channel
 * NOTE: This does not receive the GAME data as its not private
 */

import {Socket} from "phoenix";
import PlayerChannel from "./player_channel";

class GameChannel {

  constructor(socket){
    let element = document.getElementById("root");
    let gameId = element.getAttribute("data-game");
    if(!element || !gameId) { return; }
    this.joinGameChannel(socket, gameId, element);
  }

  joinGameChannel(socket, gameId, element) {
    let currentGameChannel = socket.channel("game:" + gameId);
    let _this = this;
    currentGameChannel.join().receive("ok", function(resp) {
      console.log(`initialized the Game channel for GameId: ${gameId}`);
      _this.initializePlayerChannel(socket);
    }).receive("error", reason =>
      console.log("join failed")
    )
  }

  initializePlayerChannel(socket) {
    let currentPlayerChannel = new PlayerChannel(socket);
  }

}

export default GameChannel;
