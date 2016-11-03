// Tournament Store (reducers)

var tournamentReducer = function(state = {}, action) {

  switch(action.type) {
    case "TOURNAMENT_DATA_RECIEVED":
      console.log("Tournament data received");
      //add the type.data to the state
      return state;
    default:
      return state;
  }

}

export default tournamentReducer;
