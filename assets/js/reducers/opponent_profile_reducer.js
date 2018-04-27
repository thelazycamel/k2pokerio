// Opponent Profile (reducers)

var opponentProfileReducer = function(state = {}, action) {

  switch(action.type) {
    case "OPPONENT_PROFILE:CLEAR":
      return {};
      break;
    case "OPPONENT_PROFILE:REQUEST":
      return state;
      break;
    case "OPPONENT_PROFILE:CONFIRM":
      return state;
      break;
    case "OPPONENT_PROFILE:REQUESTED":
      return Object.assign({}, state, action.resp);
      break;
    case "OPPONENT_PROFILE:CONFIRMED":
      return Object.assign({}, state, action.resp);
      break;
    case "OPPONENT_PROFILE:NEW":
      return Object.assign({}, state, action.profile);
      break;
    default:
      return state;
  }

}

export default opponentProfileReducer;
