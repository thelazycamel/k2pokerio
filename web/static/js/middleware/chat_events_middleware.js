const chatEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "CHAT:CREATE_COMMENT":
      App.chatChannel.push("chat:create_comment", {comment: action.comment, tournament_id: App.settings.tournament_id});
      break;
    default:
  }
  next(action);
}

export default chatEventsMiddleware;
