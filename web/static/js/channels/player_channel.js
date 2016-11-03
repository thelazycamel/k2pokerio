/* Player Channel
 * Only send the players game data to this channel
 */

import {Socket} from "phoenix";

class PlayerChannel {

  constructor(socket){
    if(!window.userToken) { return; }
    this.joinPlayerChannel(socket);
  }

  joinPlayerChannel(socket) {
    let currentPlayerChannel = socket.channel("player:" + window.userToken);
    currentPlayerChannel.join().receive("ok", function(resp){
      console.log(`initialized the Player channel for userToken: ${window.userToken}`);
      console.log(resp);
      $("#game-status").html(resp["status"]);
      if(resp["cards"]) {
        $.each(resp["cards"], function(index, card){
          $("#player-card-" + (index + 1)).html(card);
        });
      }
    }).receive("error", reason =>
      console.log("join failed")
    )
  }

}

export default PlayerChannel;

