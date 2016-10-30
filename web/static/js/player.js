/* Player Channel
 * Only send the players game data to this channel
 */

import {Socket} from "phoenix";

class Player {

  constructor(socket){
    if(!window.userToken) { return; }
    this.joinPlayerChannel(socket);
  }

  joinPlayerChannel(socket) {
    let playerChannel = socket.channel("player:" + window.userToken);
    playerChannel.join().receive("ok", function(resp){
      console.log(`initialized the Player channel for userToken: ${window.userToken}`);
      console.log(resp);
    }).receive("error", reason =>
      console.log("join failed")
    )
  }

}

export default Player;

