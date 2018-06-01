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
import { createStore, applyMiddleware } from "redux";
import mainStore from "./reducers/main_store";

/* Utils */
import Translate from "./utils/translate";

/* Services (ajax services, not channels) */

/* TODO tidy up these services each one should be restful, matching one per controller
 * i.e. friends_controller, tournaments_controller.

import OpponentProfileService from        "./services/opponent_profile_service"
import ScoresService from                 "./services/scores_service"
import RequestFriendService from          "./services/request_friend_service"
import ConfirmFriendService from          "./services/confirm_friend_service"
import GetFriendsService from             "./services/get_friends_service"
import SearchFriendsService from          "./services/search_friends_service"
import GetTournamentsForUserService from  "./services/get_tournaments_for_user_service"
import DestroyInviteService from          "./services/destroy_invite_service"
import DestroyTournamentService from      "./services/destroy_tournament_service"
import JoinGameService from               "./services/join_game_service"
import LogoutService from                 "./services/logout_service"
import ProfileImageService from           "./services/profile_image_service"
import UpdateBlurbService from            "./services/update_blurb_service"
import UpdatePasswordService from         "./services/update_password_service"

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

  setUpTranslations(){
    var translations = new Translate(this.settings.locale);
    this.t = function(key){ return translations.translate(key) }
  },

  initializeServices: function() {
    this.services = {};
    this.services.destroy_invite     = new DestroyInviteService();
    this.services.destroy_tournament = new DestroyTournamentService();
    this.services.opponent_profile   = new OpponentProfileService();
    this.services.get_scores         = new ScoresService();
    this.services.logout_service     = new LogoutService();
    this.services.profile_image_service = new ProfileImageService();
    this.services.update_blurb_service = new UpdateBlurbService();
    this.services.update_password_service = new UpdatePasswordService();
    this.services.request_friend     = new RequestFriendService();
    this.services.confirm_friend     = new ConfirmFriendService();
    this.services.get_friends        = new GetFriendsService();
    this.services.search_friends     = new SearchFriendsService();
    this.services.join_game_service  = new JoinGameService();
    this.services.get_tournaments_for_user_service = new GetTournamentsForUserService();
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
    let currentPage = this.pages[$("body").data("page")] || defaultPage;
    this.page = new currentPage;
  }

};

App.init();

