// Tournament Store (reducers)

var tournamentReducer = function(state = {}, action) {

  switch(action.type) {
    case "TOURNAMENT:UPDATE":
      return {...state, ...action.data};
      break;
    case "TOURNAMENT:UPDATE_WINNER_SCORE":
      return {...state, winner: action.data};
      break;
    default:
      return state;
  }

}

export default tournamentReducer;
