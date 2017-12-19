// Game Store (reducers)

var pageReducer = function(state = {tabs: {}, links: {}}, action) {

  switch(action.type) {
    case "PAGE:RESIZE":
      return Object.assign({}, state, action.page);
      break;
    case "PAGE:LINK_CLICKED":
      return Object.assign({}, state, action.page);
      break;
    default:
      return state;
  }

}

export default pageReducer;
