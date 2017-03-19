const gameEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "GAME:PLAY":
      App.gameChannel.push("game:play");
      break;
    case "GAME:DISCARD":
      App.gameChannel.push("game:discard", {card_index: action.card_index});
      break;
    case "GAME:FOLD":
      App.gameChannel.push("game:fold");
      break;
    case "GAME:NEXT_GAME":
      App.gameChannel.push("game:next_game");
      break;
    case "GAME:DATA_RECEIVED":
      if(action.game.status == "finished" || action.game.status == "new") {
        App.playerChannel.push("player:get_current_score");
      }
      break;
    default:
  }
  next(action);
};

export default gameEventsMiddleware;
