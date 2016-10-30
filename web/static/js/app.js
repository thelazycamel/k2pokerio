// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

//libs
var $ = require("jquery")

//local
import socket from "./socket"
import tournament from "./tournament"
import game from "./game"

if(window.userToken != "") {
  socket.connect();
  if($("#tournament-graph").length > 0){
  let current_tournament = new tournament(socket);
  }
  if($("#game-wrapper").length > 0){
    let current_game = new game(socket);
  }
}
