// Game Store (reducers)

var pageReducer = function(state = {}, action) {

  switch(action.type) {
    case "PAGE:RESIZE":
      return Object.assign({}, state, action.page);
      break;
    case "PAGE:LINK_CLICKED":
      return Object.assign({}, state, action.page);
      break;
    case "PAGE:SHOW_BOT_POPUP":
      return Object.assign({}, state, {botRequest: "show"});
      break;
    case "PAGE:HIDE_BOT_POPUP":
      return Object.assign({}, state, {botRequest: "hide"});
      break;
    default:
      return state;
  }

}

export default pageReducer;
