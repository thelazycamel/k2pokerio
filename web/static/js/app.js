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
import { createStore, applyMiddleware } from 'redux'
import mainStore from "./reducers/main_store"

/* Utils */

/* Services (ajax services, not channels) */

import opponentProfileService from "./services/opponent_profile_service"
import playerScoreService from "./services/player_score_service"
import requestFriendService from  "./services/request_friend_service"
import confirmFriendService from  "./services/confirm_friend_service"
import searchFriendsService from  "./services/search_friends_service"


/* pages */

import defaultPage from "./pages/default"
import tournamentIndexPage from "./pages/tournament/index"
import tournamentNewPage from "./pages/tournament/new"
import gamePlayPage from "./pages/game/play"
import profileEditPage from "./pages/profile/edit"

/* middleware */
import gameEventsMiddleware from "./middleware/game_events_middleware"
import pageEventsMiddleware from "./middleware/page_events_middleware"
import chatEventsMiddleware from "./middleware/chat_events_middleware"

window.App = {

  init: function() {
    this.setConfig();
    this.initializeServices();
    this.createReduxStore();
    this.setUpCurrentPage();
  },

  setConfig: function() {
    this.settings = {};
    let configurations = document.getElementsByTagName("body")[0].dataset;
    configurations["csrf_token"] = $("meta[name='csrf_token']").attr("content");
    this.settings = Object.assign({}, configurations);
  },

  // TODO: think about moving these to the pages that require them so they dont
  // have to be loaded on every page.
  //
  initializeServices: function() {
    this.services = {};
    this.services.opponent_profile = new opponentProfileService();
    this.services.player_score = new playerScoreService();
    this.services.request_friend = new requestFriendService();
    this.services.confirm_friend = new confirmFriendService();
    this.services.search_friends = new searchFriendsService();
  },

  createReduxStore: function() {
    let middleware = applyMiddleware(gameEventsMiddleware, pageEventsMiddleware, chatEventsMiddleware);
    this.store = createStore(mainStore, middleware);
  },

  pages: {
    "gamePlay":        gamePlayPage,
    "tournamentIndex": tournamentIndexPage,
    "tournamentNew":   tournamentNewPage,
    "profileEdit":     profileEditPage
  },

  setUpCurrentPage: function(){
    let currentPage = this.pages[$("body").data("page")] || defaultPage;
    this.page = new currentPage;
  }

};

App.init();

