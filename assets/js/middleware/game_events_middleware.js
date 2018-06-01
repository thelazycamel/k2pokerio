import GameChannel from "../channels/game_channel"

const gameEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "GAME:JOINED":
      new GameChannel(action.game_id);
      break;
    case "GAME:JOIN_FAILED":
      window.location = "/";
      break;
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
    case "GAME:WAITING_PING":
      App.gameChannel.push("game:waiting_ping");
      break;
    case "GAME:DATA_RECEIVED":
      switch(action.game.player_status){
        case "ready":
          App.store.dispatch({type: "PAGE:SET_WAITING_PING"});
          break;
        default:
          App.store.dispatch({type: "PAGE:CLEAR_WAITING_PING"});
      }
      switch(action.game.status) {
        case "finished":
          App.services.tournaments.get_scores();
          break;
        case "deal":
          App.services.opponent_profile.call();
          App.store.dispatch({type: "PAGE:CLEAR_BOT_TIMER"});
          App.store.dispatch({type: "GAME:REMOVE_BOT_BUTTON"});
          break;
        case "new":
          break;
        case "standby":
          App.store.dispatch({type: "PAGE:SET_BOT_TIMER"});
          break;
        default:
          App.store.dispatch({type: "PAGE:CLEAR_BOT_TIMER"});
          App.store.dispatch({type: "GAME:REMOVE_BOT_BUTTON"});
      }
  }
  next(action);
};

export default gameEventsMiddleware;
