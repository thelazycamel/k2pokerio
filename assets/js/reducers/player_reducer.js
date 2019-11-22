// Player Store (reducers)

var playerReducer = function(state = {}, action) {

  switch(action.type) {
    case "PLAYER:UPDATE_PLAYER_SCORE":
      return {...state, ...action.data};
      break;
    default:
      return state;
  }

}

export default playerReducer;
