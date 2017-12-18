class ScoresService {

  constructor(){
    this.url = "/tournaments/get_scores/";
  }

  call() {
    let _this = this;
    $.ajax({
      url: this.url,
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

export default ScoresService;
