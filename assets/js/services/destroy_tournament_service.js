class DestroyTournamentService {

  call(id) {
    let _this = this;
    $.ajax({
      url: "/tournaments/"+id,
      method: "DELETE",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    }).done(function(resp){
      App.store.dispatch({type: "TOURNAMENT:DESTROYED", data: resp});
    }).fail(function(resp){
      console.log("delete tournament failed");
    });
  }

}

export default DestroyTournamentService;
