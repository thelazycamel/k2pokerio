import PageComponentManager from "../utils/page_component_manager";
const pageEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "PAGE:SET_BOT_TIMER":
      App.page.setBotRequest();
      break;
    case "PAGE:CLEAR_BOT_TIMER":
      App.page.clearBotRequest();
      break;
  }
  next(action);
};

export default pageEventsMiddleware;
