const tournamentEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "TOURNAMENT:DESTROY_INVITE":
      App.services.destroy_invite.call(action.invite_id);
      break;
    case "TOURNAMENT:REFRESH_DATA":
      App.tournamentChannel.push("tournament:refresh_data", {tournament_id: action.tournament_id});
      break;
    case "TOURNAMENT:LOSER":
      App.page.showTournamentLoserPopup(action);
      break;
    case "TOURNAMENT:WINNER":
      App.page.showTournamentWinnerPopup(action);
      break;
    case "TOURNAMENT:DESTROY_TOURNAMENT":
      App.services.tournaments.destroy(action.tournament_id);
      break;
  }
  next(action);
};

export default tournamentEventsMiddleware;
