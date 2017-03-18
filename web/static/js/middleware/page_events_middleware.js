import PageComponentManager from "../utils/page_component_manager";
const pageEventsMiddleware = store => next => action => {
  switch(action.type) {
    case "PAGE:LINK_CLICKED":
      console.log(action);
      new PageComponentManager().showTab(action.tab, action.page.links);
      break;
    default:
  }
  next(action);
};

export default pageEventsMiddleware;
