class DestroyTournamentService {

  call(id) {
    let _this = this;
    $.ajax({
      url: "/tournaments/"+id,
      method: "DELETE",
      beforeSend: function(xhr) { xhr.setRequestHeader('x-csrf-token', App.settings.csrf_token)}
    });
  }

}

export default DestroyTournamentService;
