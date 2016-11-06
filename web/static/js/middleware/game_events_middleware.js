const gameEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "PLAY":
      console.log("picking up the play event in the middleware");
      App.playerChannel.push("player:play", {}).receive("ok", function(response){
        App.store.dispatch({type: "GAME_DATA_RECEIVED", game: response});
        App.store.dispatch({type: "PLAYED"});
      }).receive("error", function(reason) {
        console.log("play action failed", reason);
      });
      break;
    case "DISCARD":
      console.log("picking up the discard event in the middleware for card index: ", action.card);
      break;
    case "FOLD":
      alert("CRAP CARDS EH!?");
      break;
    case "PLAYED":
      /* Every time the player has played, send this, which triggers */
      /* the event to be sent to the game socket and broadcast to the other player */
      App.gameChannel.push("game:played").receive("ok", function(response){
        console.log("played pushed ok");
      });

    default:
  }
  next(action);
};

export default gameEventsMiddleware;
