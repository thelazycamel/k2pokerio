// Game Store (reducers)

var gameReducer = function(state = {}, action) {

  switch(action.type) {
    case "PLAY":
      console.log("You pressed play");
      return state;
    case "DISCARD":
      console.log("You pressed dicard");
      return state;
    case "FOLD":
      console.log("You pressed fold");
       return state;
    case "GAME_DATA_RECIEVED":
      console.log("You have recieved some new data from the server");
      //add the type.data to the state
      return state;
    default:
      return state;
  }

}

export default gameReducer;
