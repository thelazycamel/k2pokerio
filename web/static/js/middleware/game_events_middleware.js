const gameEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "PLAY":
      App.gameChannel.push("game:play");
      break;
    case "DISCARD":
      console.log("pushing to game:discard => ", action.card_index);
      App.gameChannel.push("game:discard", {card_index: action.card_index});
      break;
    case "FOLD":
      App.gameChannel.push("game:fold");
      break;

    default:
  }
  next(action);
};

export default gameEventsMiddleware;
