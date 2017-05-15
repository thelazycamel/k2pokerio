class OpponentProfileService {

  constructor(){
    this.url = "/games/opponent_profile/";
  }

  call() {
    let _this = this;
    $.ajax({
      url: this.url,
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

export default OpponentProfileService;
