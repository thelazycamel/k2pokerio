// Chat Store (reducers)

var chatReducer = function(state = {comments:[]}, action) {

  switch(action.type) {
    case "CHAT:CREATE":
      return state;
      break;
    case "CHAT:COMMENT_RECEIVED":
      return { chosen: [...state.comments, action.comment] }
      break;
    default:
      return state;
  }

}

export default chatReducer;
