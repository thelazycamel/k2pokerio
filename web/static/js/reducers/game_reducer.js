// Game Store (reducers)

var gameReducer = function(state = {}, action) {

  switch(action.type) {
    case "PLAY":
      return state;
    case "DISCARD":
      return state;
    case "FOLD":
       return state;
    case "GAME_DATA_RECEIVED":
      return Object.assign({}, action.game);
    default:
      return state;
  }

}

export default gameReducer;
