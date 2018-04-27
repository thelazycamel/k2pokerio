// Tournament Store (reducers)

var tournamentReducer = function(state = {}, action) {

  switch(action.type) {
    case "TOURNAMENT:UPDATE":
      return Object.assign({}, state, action.data);
      break;
    case "TOURNAMENT:RECEIVED_USER_TOURNAMENTS":
      return Object.assign({}, state, action.data);
      break;
    case "TOURNAMENT:UPDATE_WINNER_SCORE":
      return Object.assign({}, state, {winner: action.data});
      break;
    case "TOURNAMENT:DESTROYED":
      let tournaments = state.current;
      tournaments.splice(tournaments.findIndex(function(tournament){ return tournament.id == action.data.tournament_id}));
      return Object.assign({}, state, {current: tournaments});
      break;
    case "TOURNAMENT:INVITE_DESTROYED":
      let invites = state.invites;
      invites.splice(invites.findIndex(function(invite){ return invite.id == action.data.invite_id}));
      return Object.assign({}, state, {invites: invites});
      break;
    default:
      return state;
  }

}

export default tournamentReducer;
