// Player Store (reducers)

var playerReducer = function(state = {}, action) {

  switch(action.type) {
    case "PLAYER:UPDATE_PLAYER_SCORE":
      console.log("score received", action.score);
      return Object.assign({}, state, action.score);
    default:
      return state;
  }

}

export default playerReducer;
