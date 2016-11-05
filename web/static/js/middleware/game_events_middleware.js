const gameEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "PLAY":
      console.log("picking up the play event in the middleware");
      window.currentPlayerChannel.push("PLAY", {}).receive("ok", function(response){
        /* TODO check for failures */
        console.log("received from play: ", response);
        window.store.dispatch({type: "GAME_DATA_RECEIVED", game: response});
      });

      break;
    case "DISCARD":
      console.log("picking up the discard event in the middleware for card index: ", action.card);
      break;
    case "FOLD":
      alert("CRAP CARDS EH!?");
      break;
    default:
  }
  next(action);
};

export default gameEventsMiddleware;
