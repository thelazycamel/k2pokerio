class DestroyInviteService {

  constructor(){
    this.url = "/invitation/destroy";
  }

  call(id) {
    let _this = this;
    $.ajax({
      url: this.url,
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

export default DestroyInviteService;
