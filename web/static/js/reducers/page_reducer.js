// Game Store (reducers)

var pageReducer = function(state = {}, action) {

  switch(action.type) {
    case "PAGE_RESIZE":
      return Object.assign({}, action.page);
    case "PAGE_LINK_CLICKED":
      return Object.assign({}, action.page);
    default:
      return state;
  }

}

export default pageReducer;
