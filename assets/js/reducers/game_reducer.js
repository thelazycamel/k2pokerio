// Game Store (reducers)

var gameReducer = function(state = {}, action) {

  switch(action.type) {
    case "GAME:PLAY":
      return Object.assign({}, state, {disable_button: true});
    case "GAME:DISCARD":
      let cards = state.cards;
      cards[action.card_index] = "discarded";
      if(state.status == "river"){
        cards = ["discarded", "discarded"];
      }
      return Object.assign({}, state, {cards: cards});
      break;
    case "GAME:FOLD":
       return state;
       break;
    case "GAME:ENABLE_PLAY_BUTTON":
      return Object.assign({}, state, {disable_button: false});
    case "GAME:DATA_RECEIVED":
      let buttonState = state.disable_button ? "timeout" : false;
      return Object.assign({}, {disable_button: buttonState}, action.game);
      break; 
    case "GAME:NEXT_GAME":
      return state;
      break;
    case "GAME:SHOW_BOT_BUTTON":
      return Object.assign({}, state, {show_bot_request: true});
      break;
    case "GAME:REMOVE_BOT_BUTTON":
      return Object.assign({}, state, {show_bot_request: false});
      break;
    default:
      return state;
  }

}

export default gameReducer;
