class JoinGameService {

  constructor(){
    this.url = "/games/join";
  }

  call() {
    let _this = this;
    $.ajax({
      url: this.url,
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "GAME:JOINED", game_id: resp.game_id});
    }).fail(function(resp){
      App.store.dispatch({type: "GAME:JOIN_FAILED", resp: {friend: "na"}});
    });
  }

}

export default JoinGameService;
