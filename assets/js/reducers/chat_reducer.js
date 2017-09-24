// Chat Store (reducers)

var chatReducer = function(state = {comments:[]}, action) {

  switch(action.type) {
    case "CHAT:CREATE_COMMENT":
      return state;
      break;
    case "CHAT:COMMENT_RECEIVED":
      return { comments: [...state.comments, action.comment] }
      break;
    case "CHAT:NEW_LIST_RECEIVED":
      return { comments: action.comments }
      break;
    default:
      return state;
  }

}

export default chatReducer;
