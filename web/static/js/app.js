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
import { createStore, applyMiddleware } from 'redux'
import mainStore from "./reducers/main_store"

/* Utils */
import cardAnimator from "./utils/card_animator"

/* pages */
import tournamentShowPage from "./pages/tournament/show"
import tournamentIndexPage from "./pages/tournament/index"
import gameShowPage from "./pages/game/show"
import gameEventsMiddleware from "./middleware/game_events_middleware"
import pageEventsMiddleware from "./middleware/page_events_middleware"

window.App = {

  init: function() {
    this.cardAnimator = new cardAnimator();
    this.createReduxStore();
    this.connectSocket();
    this.setUpCurrentPage();
  },

  createReduxStore: function() {
    let middleware = applyMiddleware(gameEventsMiddleware, pageEventsMiddleware);
    this.store = createStore(mainStore, middleware);
  },

  connectSocket: function() {
    if(window.userToken != "") {
      this.socket = socket;
      this.socket.connect();
    }
  },

  setUpCurrentPage: function(){
    let currentPage = this.pages()[$("body").data("page")]
    this.page = new currentPage;
  },


  pages: function() {
    return { "gameShow":        gameShowPage,
             "tournamentShow":  tournamentShowPage,
             "tournamentIndex": tournamentIndexPage
    }
  }

};

App.init();

