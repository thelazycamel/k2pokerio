// Opponent Profile (reducers)

var opponentProfileReducer = function(state = {}, action) {

  switch(action.type) {
    case "OPPONENT_PROFILE:CLEAR":
      return {};
    case "OPPONENT_PROFILE:REQUEST":
      return state;
    case "OPPONENT_PROFILE:CONFIRM":
      return state;
    case "OPPONENT_PROFILE:REQUESTED":
      return Object.assign({}, state, action.resp);
    case "OPPONENT_PROFILE:CONFIRMED":
      return Object.assign({}, state, action.resp);
    case "OPPONENT_PROFILE:NEW":
      return Object.assign({}, state, action.profile);
      break;
    default:
      return state;
  }

}

export default opponentProfileReducer;
