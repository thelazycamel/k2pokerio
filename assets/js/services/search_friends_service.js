class SearchFriendsService {

  constructor(){
    this.url = "/friends/search";
  }

  call(payload, callback) {
    let _this = this;
    $.ajax({
      url: this.url,
      method: "POST",
      dataType: "json",
      data: payload,
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      return callback(resp);
    }).fail(function(resp){
      alert("request failed");
      return callback(resp);
    });
  }

}

export default SearchFriendsService;
