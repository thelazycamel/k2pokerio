// Tournament Store (reducers)

var tournamentReducer = function(state = {}, action) {

  switch(action.type) {
    case "TOURNAMENT:UPDATE":
      return Object.assign({}, state, action.data);
      break;
    case "TOURNAMENT:UPDATE_WINNER_SCORE":
      return Object.assign({}, state, {winner: action.data});
      break;
    default:
      return state;
  }

}

export default tournamentReducer;
