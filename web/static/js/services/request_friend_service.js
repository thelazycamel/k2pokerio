class FriendRequestService {

  constructor(){
    this.url = "/friend/request";
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
      App.store.dispatch({type: "OPPONENT_PROFILE:REQUESTED", resp: resp});
    }).fail(function(resp){
      App.store.dispatch({type: "OPPONENT_PROFILE:REQUESTED", resp: {friend: "na"}});
    });
  }

}

export default FriendRequestService;
