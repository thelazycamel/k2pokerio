// Opponent Profile (reducers)

var opponentProfileReducer = function(state = {}, action) {

  switch(action.type) {
    case "OPPONENT_PROFILE:NEW":
      return Object.assign({}, state, action.profile);
      break;
    default:
      return state;
  }

}

export default opponentProfileReducer;
