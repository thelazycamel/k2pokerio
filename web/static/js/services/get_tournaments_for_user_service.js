class GetTournamentsForUserService {

  constructor(){
    this.url = "/tournaments/for_user";
  }

  call() {
    let _this = this;
    $.ajax({
      url: this.url,
      method: "POST",
      dataType: "json",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "TOURNAMENT:RECEIVED_USER_TOURNAMENTS", data: resp});
    }).fail(function(resp){
      console.log("failed getting user tournaments");
    });
  }

}

export default GetTournamentsForUserService;
