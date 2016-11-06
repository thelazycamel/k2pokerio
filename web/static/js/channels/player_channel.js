/* Player Channel
 * Only send the players game data to this channel
 * NOTE Player channel receives the GAME data as this is a
 * private channel to the player
 */

class PlayerChannel {

  constructor(){
    if(!window.userToken) { return; }
    this.joinPlayerChannel();
  }

  joinPlayerChannel() {
    App.playerChannel = App.socket.channel("player:" + window.userToken);
    App.playerChannel.join().receive("ok", function(resp){
      App.store.dispatch({type: "GAME_DATA_RECEIVED", game: resp})
    }).receive("error", reason =>
      console.log("join failed")
    )
  }

}

export default PlayerChannel;

