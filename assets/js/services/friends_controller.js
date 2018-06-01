export default class FriendsController {

  constructor(){
    this.baseUrl = "/friends";
  }

  index() {
    return (
      fetch(this.baseUrl,
        { headers: {'x-csrf-token': App.settings.csrf_token},
          credentials: 'same-origin'}
      ).then(response => { return response.json() })
    )
  }

  create(id) {
    let _this = this;
    $.ajax({
      url: this.baseUrl,
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

  confirm(id) {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/confirm`,
      method: "POST",
      dataType: "json",
      data: {id: id},
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "OPPONENT_PROFILE:CONFIRMED", resp: resp});
    }).fail(function(resp){
      App.store.dispatch({type: "OPPONENT_PROFILE:CONFIRMED", resp: {friend: "na"}});
    });
  }

  search(query) {
    let _this = this;
    $.ajax({
      url: `${this.baseUrl}/search`,
      method: "GET",
      dataType: "json",
      data: {search: search},
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){

    }).fail(function(resp){

    });
  }

}
