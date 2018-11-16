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

// libs

/* local */
import { createStore, applyMiddleware } from "redux";
import mainStore from "./reducers/main_store";

/* Utils */
import Translate from "./utils/translate";
import Utils from "./utils/utils";

/* API Services */

import FriendsController from             "./services/friends_controller"
import GamesController from               "./services/games_controller"
import InvitationsController from         "./services/invitations_controller"
import LogoutService from                 "./services/logout_service"
import ProfileController from             "./services/profile_controller"
import TournamentsController from         "./services/tournaments_controller"

/* pages */

import defaultPage from "./pages/default"
import homePage from "./pages/page/index"
import tournamentIndexPage from "./pages/tournament/index"
import tournamentShowPage from "./pages/tournament/show"
import tournamentNewPage from "./pages/tournament/new"
import gamePlayPage from "./pages/game/play"
import profileEditPage from "./pages/profile/edit"

/* middleware */
import gameEventsMiddleware from "./middleware/game_events_middleware"
import pageEventsMiddleware from "./middleware/page_events_middleware"
import chatEventsMiddleware from "./middleware/chat_events_middleware"
import tournamentEventsMiddleware from "./middleware/tournament_events_middleware"

window.App = {

  init: function() {
    this.setConfig();
    this.setUpTranslations();
    this.setUpUtils();
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

  setUpUtils(){
    this.utils = new Utils;
  },

  setUpTranslations(){
    var translations = new Translate(this.settings.locale);
    this.t = function(key){ return translations.translate(key) }
  },

  initializeServices: function() {
    this.services = {};
    this.services.friends            = new FriendsController();
    this.services.games              = new GamesController();
    this.services.invitations        = new InvitationsController();
    this.services.tournaments        = new TournamentsController();
    this.services.profile            = new ProfileController();
    this.services.logout_service     = new LogoutService();
  },

  createReduxStore: function() {
    let middleware = applyMiddleware(
        gameEventsMiddleware,
        pageEventsMiddleware,
        chatEventsMiddleware,
        tournamentEventsMiddleware
    );
    this.store = createStore(mainStore, middleware);
  },

  pages: {
    "pageIndex":       homePage,
    "gamePlay":        gamePlayPage,
    "tournamentIndex": tournamentIndexPage,
    "tournamentShow":  tournamentShowPage,
    "tournamentNew":   tournamentNewPage,
    "profileEdit":     profileEditPage
  },

  setUpCurrentPage: function(){
    let bodyElement = document.getElementsByTagName("body")[0];
    let pageName = bodyElement.dataset.page;
    let currentPage = this.pages[pageName] || defaultPage;
    this.page = new currentPage;
  }

};

App.init();

