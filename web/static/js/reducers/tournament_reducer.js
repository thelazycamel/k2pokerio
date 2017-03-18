// Tournament Store (reducers)

var tournamentReducer = function(state = {}, action) {

  switch(action.type) {
    case "TOURNAMENT:DATA_RECEIVED":
      console.log("Tournament data received");
      return state;
    default:
      return state;
  }

}

export default tournamentReducer;
