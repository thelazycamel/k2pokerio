// Tournament Store (reducers)

var tournamentReducer = function(state = {}, action) {

  switch(action.type) {
    case "TOURNAMENT:UPDATE_COUNT":
      console.log("HERE: COUNT: ", action)
      return Object.assign({}, state, {player_count: action.player_count});
    default:
      return state;
  }

}

export default tournamentReducer;
