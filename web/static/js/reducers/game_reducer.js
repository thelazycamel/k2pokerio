// Game Store (reducers)

var gameReducer = function(state = {}, action) {

  switch(action.type) {
    case "GAME:PLAY":
      return state;
    case "GAME:DISCARD":
      return state;
    case "GAME:FOLD":
       return state;
    case "GAME:DATA_RECEIVED":
      return Object.assign({}, action.game);
    case "GAME:NEXT_GAME":
      return state;
    default:
      return state;
  }

}

export default gameReducer;
