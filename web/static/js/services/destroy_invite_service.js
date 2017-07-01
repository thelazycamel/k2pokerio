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
    });
  }

}

export default DestroyInviteService;
