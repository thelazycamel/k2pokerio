import PageComponentManager from "../utils/page_component_manager";
const pageEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "PAGE:LINK_CLICKED":
      new PageComponentManager().showTab(action.tab, action.page.links);
      break;
    case "PAGE:SET_BOT_POPUP":
      App.page.setBotRequest();
      break;
    case "PAGE:CLEAR_BOT_POPUP":
      App.page.clearBotRequest();
      break;
    default:
  }
  next(action);
};

export default pageEventsMiddleware;
