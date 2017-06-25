// Tournament Store (reducers)

var tournamentReducer = function(state = {}, action) {

  switch(action.type) {
    case "TOURNAMENT:UPDATE":
      return Object.assign({}, state, action.data);
    case "TOURNAMENT:RECEIVED_USER_TOURNAMENTS":
      console.log(action.data);
      return Object.assign({}, state, action.data);
    default:
      return state;
  }

}

export default tournamentReducer;
