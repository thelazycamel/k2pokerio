import {Socket} from "phoenix"

let socket = {};

// check for window object as doesn't exist in tests, hmmpf
// if you are adding sockets to a page, ensure player_id is passed in the params
// from the contoller
if(typeof window === "object") {
  socket = new Socket("/socket", {
    params: {token:  window.userToken},
    logger: (kind, msg, data) => {
      console.log(`${kind}: ${msg}`, data);
    }
  });
}

export default socket;
