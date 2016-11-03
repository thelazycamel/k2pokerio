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

/* local */
import socket from "./socket"
import store from "./reducers/store"

/* pages */
import tournamentShowPage from "./pages/tournament/show"
import tournamentIndexPage from "./pages/tournament/index"
import gameShowPage from "./pages/game/show"

(function(){

  let pages = [tournamentShowPage, tournamentIndexPage, gameShowPage];

  if(window.userToken != "") {
    socket.connect();
  }

  // load all the pages javascript, they will not fire if
  // we are not on their page, add the import above, and then
  // add it to the array below
  //
  let initialized_pages = []
  $.each(pages, function(index, page){
    initialized_pages[index] = new page({socket: socket});
  });

})();

