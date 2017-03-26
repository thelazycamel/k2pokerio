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
    case "GAME:BOT_REQUEST":
      App.gameChannel.push("game:bot_request");
      break;
    case "GAME:DATA_RECEIVED":
      switch(action.game.status) {
        case "finished":
          App.playerChannel.push("player:get_current_score");
          break;
        case "new":
          App.playerChannel.push("player:get_current_score");
          App.store.dispatch({type: "PAGE:CLEAR_BOT_POPUP"});
          App.store.dispatch({type: "PAGE:HIDE_BOT_POPUP"});
          break;
        case "standby":
          App.store.dispatch({type: "PAGE:SET_BOT_POPUP"});
          break;
        default:
          App.store.dispatch({type: "PAGE:CLEAR_BOT_POPUP"});
          App.store.dispatch({type: "PAGE:HIDE_BOT_POPUP"});
      }
    default:
  }
  next(action);
};

export default gameEventsMiddleware;
