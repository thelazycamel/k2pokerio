// Game Store (reducers)

var gameReducer = function(state = {}, action) {

  switch(action.type) {
    case "GAME:PLAY":
      return state;
    case "GAME:DISCARD":
      //TODO move this probably to k2poker
      let cards = state.cards;
      cards[action.card_index] = "discarded";
      if(state.status == "river"){
        cards = ["discarded", "discarded"];
      }
      return Object.assign({}, state, {cards: cards});
    case "GAME:FOLD":
       return state;
    case "GAME:DATA_RECEIVED":
      return Object.assign({}, action.game);
    case "GAME:NEXT_GAME":
      return state;
    case "GAME:SHOW_BOT_BUTTON":
      return Object.assign({}, state, {bot_request: "show"});
      break;
    case "GAME:REMOVE_BOT_BUTTON":
      return Object.assign({}, state, {bot_request: "hide"});
      break;
    default:
      return state;
  }

}

export default gameReducer;
