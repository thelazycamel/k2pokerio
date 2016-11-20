// Game Store (reducers)

var gameReducer = function(state = {}, action) {

  /* TODO PREPEND ALL ACTIONS WITH GAME: */

  switch(action.type) {
    case "PLAY":
      return state;
    case "DISCARD":
      return state;
    case "FOLD":
       return state;
    case "GAME_DATA_RECEIVED":
      return Object.assign({}, action.game);
    case "NEXT_GAME":
      return state;
    default:
      return state;
  }

}

export default gameReducer;
