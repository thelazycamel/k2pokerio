const tournamentEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "TOURNAMENT:REFRESH_DATA":
      App.tournamentChannel.push("tournament:refresh_data", {tournament_id: action.tournament_id});
      break;
    case "TOURNAMENT:LOSER":
      App.page.showTournamentLoserPopup(action);
      break;
    case "TOURNAMENT:WINNER":
      App.page.showTournamentWinnerPopup(action);
      break;
  }
  next(action);
};

export default tournamentEventsMiddleware;
