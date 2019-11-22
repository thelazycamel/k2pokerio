// Game Store (reducers)

var gameReducer = function(state = {}, action) {

  switch(action.type) {
    case "GAME:PLAY":
      return {...state, disable_button: true};
    case "GAME:DISCARD":
      let cards = state.cards;
      cards[action.card_index] = "discarded";
      if(state.status == "river"){
        cards = ["discarded", "discarded"];
      }
      return {...state, cards: cards};
      break;
    case "GAME:FOLD":
      return state;
      break;
    case "GAME:COUNTDOWN":
      return {...state, countDown: action.countDown};
      break;
    case "GAME:ENABLE_PLAY_BUTTON":
      return {...state, disable_button: false};
      break;
    case "GAME:DATA_RECEIVED":
      let buttonState = state.disable_button ? "timeout" : false;
      return {...action.game, disable_button: buttonState};
      break;
    case "GAME:NEXT_GAME":
      return state;
      break;
    case "GAME:SHOW_BOT_BUTTON":
      return {...state, show_bot_request: true};
      break;
    case "GAME:REMOVE_BOT_BUTTON":
      return {...state, show_bot_request: false};
      break;
    default:
      return state;
  }

}

export default gameReducer;
