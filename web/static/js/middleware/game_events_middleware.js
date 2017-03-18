const gameEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "GAME_PLAY":
      App.gameChannel.push("game:play");
      break;
    case "GAME_DISCARD":
      App.gameChannel.push("game:discard", {card_index: action.card_index});
      break;
    case "GAME_FOLD":
      App.gameChannel.push("game:fold");
      break;
    case "GAME_NEXT_GAME":
      App.gameChannel.push("game:next_game");
      break;
    case "GAME_DATA_RECEIVED":
      if(action.game.status == "finished" || action.game.status == "new") {
        App.playerChannel.push("player:get_current_score");
      }
      break;
    default:
  }
  next(action);
};

export default gameEventsMiddleware;
