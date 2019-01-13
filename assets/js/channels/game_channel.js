export default class GameChannel {

  constructor(game_id){
    this.joinGameChannel(game_id);
  }

  joinGameChannel(game_id) {
    if(game_id) {
      App.gameChannel = App.socket.channel("game:" + game_id);
      App.gameChannel.join().receive("ok", function(resp) {
        App.gameChannel.push("game:refresh_data");
        App.services.games.opponent_profile();
        App.settings["game_id"] = game_id;
        App.services.tournaments.get_scores();
      }).receive("error", reason => {
        console.log("join failed");
        window.location = "/";
        }
      )

      App.gameChannel.on("game:new_game_data", function(resp) {
        if(resp.error) {
          window.location = "/";
        } else {
          App.store.dispatch({type: "GAME:DATA_RECEIVED", game: resp});
        }
      });

      App.gameChannel.on("game:badge_awarded", function(resp) {
        App.page.showBadgeAlert(resp.badges);
      });

    } else {
      window.location = "/";
    }
  }


}

