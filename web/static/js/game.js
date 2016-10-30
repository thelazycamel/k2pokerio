import {Socket} from "phoenix";

/* TODO create the game channel passing back only the data for the
 * current player */

class Game {

  constructor(socket){
    let element = document.getElementById("game-wrapper");
    let gameId = element.getAttribute("data-game");
    if(!element || !gameId) { return; }
    this.joinGameChannel(socket, gameId, element);
  }

  joinGameChannel(socket, gameId, element) {
    let gameChannel = socket.channel("game:" + gameId);
    gameChannel.join().receive("ok", resp =>
      console.log(`initialized the Game channel for GameId: ${gameId}`)
    ).receive("error", reason =>
      console.log("join failed")
    )
  }

}

export default Game;
