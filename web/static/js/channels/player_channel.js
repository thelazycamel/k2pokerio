/* Player Channel
 * Only send the players game data to this channel
 * NOTE Player channel receives the GAME data as this is a
 * private channel to the player
 */

import {Socket} from "phoenix";

class PlayerChannel {

  constructor(socket, store){
    if(!window.userToken) { return; }
    this.joinPlayerChannel(socket, store);
  }

  joinPlayerChannel(socket) {
    window.currentPlayerChannel = socket.channel("player:" + window.userToken);
    window.currentPlayerChannel.join().receive("ok", function(resp){
      window.store.dispatch({type: "GAME_DATA_RECEIVED", game: resp})
    }).receive("error", reason =>
      console.log("join failed")
    )
  }

}

export default PlayerChannel;

