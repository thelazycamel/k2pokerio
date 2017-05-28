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
      App.store.dispatch({type: "OPPONENT_PROFILE:CLEAR"});
      App.gameChannel.leave().receive("ok", ()=> {
        delete App.gameChannel;
        App.page.loadNewGame();
      });
      break;
    case "GAME:BOT_REQUEST":
      App.gameChannel.push("game:bot_request");
      break;
    case "GAME:DATA_RECEIVED":
      switch(action.game.status) {
        case "finished":
          App.services.player_score.call();
          break;
        case "deal":
          App.services.opponent_profile.call();
          App.store.dispatch({type: "PAGE:CLEAR_BOT_POPUP"});
          App.store.dispatch({type: "PAGE:HIDE_BOT_POPUP"});
          break;
        case "new":
          break;
        case "standby":
          App.store.dispatch({type: "PAGE:SET_BOT_POPUP"});
          break;
        default:
          App.store.dispatch({type: "PAGE:CLEAR_BOT_POPUP"});
          App.store.dispatch({type: "PAGE:HIDE_BOT_POPUP"});
      }
  }
  next(action);
};

export default gameEventsMiddleware;
