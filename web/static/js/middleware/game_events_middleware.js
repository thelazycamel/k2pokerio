const gameEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "PLAY":
      App.gameChannel.push("game:play");
      break;
    case "DISCARD":
      App.gameChannel.push("game:discard", {card_index: action.card_index});
      break;
    case "FOLD":
      App.gameChannel.push("game:fold");
      break;
    case "NEXT_GAME":
      App.gameChannel.push("game:next_game");
      break;
    default:
  }
  next(action);
};

export default gameEventsMiddleware;
