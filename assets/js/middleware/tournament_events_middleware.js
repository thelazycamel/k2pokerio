const tournamentEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "TOURNAMENT:DESTROY_INVITE":
      App.services.destroy_invite.call(action.invite_id);
      break;
    case "TOURNAMENT:DESTROY_TOURNAMENT":
      App.services.destroy_tournament.call(action.tournament_id);
      break;
  }
  next(action);
};

export default tournamentEventsMiddleware;