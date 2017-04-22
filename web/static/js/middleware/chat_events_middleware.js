const chatEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "CHAT:NEW_COMMENT":
      App.chatChannel.push("chat:new_comment", action.comment);
      break;
    default:
  }
}
