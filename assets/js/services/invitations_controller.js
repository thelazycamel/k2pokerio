export default class InvitationsController {

  constructor(){
    this.baseUrl = "/invitation";
  }

  destroy(id) {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/destroy`,
      method: "POST",
      dataType: "json",
      data: {id: id},
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "TOURNAMENT:INVITE_DESTROYED", data: resp});
    }).fail(function(resp){
      console.log("delete invite failed");
    });
  }

}

