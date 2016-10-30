/* Game Channel
 * Only sends and receives pings to confirm played
 * all player data is sent via the player channel
 */

import {Socket} from "phoenix";
import player from "./player";

class Game {

  constructor(socket){
    let element = document.getElementById("game-wrapper");
    let gameId = element.getAttribute("data-game");
    if(!element || !gameId) { return; }
    this.joinGameChannel(socket, gameId, element);
  }

  joinGameChannel(socket, gameId, element) {
    let gameChannel = socket.channel("game:" + gameId);
    let _this = this;
    gameChannel.join().receive("ok", function(resp) {
      console.log(`initialized the Game channel for GameId: ${gameId}`);
      _this.initializePlayerChannel(socket);
    }).receive("error", reason =>
      console.log("join failed")
    )
  }

  initializePlayerChannel(socket) {
    let playerChannel = new player(socket);
  }

}

export default Game;
