export default class TournamentsController {

  constructor(){
    this.baseUrl = "/tournaments";
  }

  destroy(id) {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/${id}`,
      method: "DELETE",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "TOURNAMENT:DESTROYED", data: resp});
    }).fail(function(resp){
      console.log("delete tournament failed");
    });
  }

  for_user() {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/for_user`,
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "TOURNAMENT:RECEIVED_USER_TOURNAMENTS", data: resp});
    }).fail(function(resp){
      console.log("failed getting user tournaments");
    });
  }

  get_scores() {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/get_scores`,
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "PLAYER:UPDATE_PLAYER_SCORE", data: resp.current_player});
      App.store.dispatch({type: "TOURNAMENT:UPDATE_WINNER_SCORE", data: resp.other_player});
    }).fail(function(resp){
      App.store.dispatch({type: "PLAYER:UPDATE_PLAYER_SCORE", current_score: 1, username: "error"});
    });
  }

}
