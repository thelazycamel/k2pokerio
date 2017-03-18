// Game Store (reducers)

var pageReducer = function(state = {}, action) {

  switch(action.type) {
    case "PAGE:RESIZE":
      return Object.assign({}, action.page);
    case "PAGE:LINK_CLICKED":
      return Object.assign({}, action.page);
    default:
      return state;
  }

}

export default pageReducer;
