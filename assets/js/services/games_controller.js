export default class GameController {

  constructor(){
    this.baseUrl = "/games";
  }

  join() {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/join`,
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "GAME:JOINED", game_id: resp.game_id});
    }).fail(function(resp){
      App.store.dispatch({type: "GAME:JOIN_FAILED", resp: {friend: "na"}});
    });
  }

  opponent_profile() {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/opponent_profile`,
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "OPPONENT_PROFILE:NEW", profile: resp});
    }).fail(function(){
      console.log("unable to retrieve opponent profile data");
    });
  }

}

