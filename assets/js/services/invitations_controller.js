export default class InvitationsController {

  constructor(){
    this.baseUrl = "/invitation";
  }

  destroy(id) {
    fetch(`${this.baseUrl}/${id}`, {
      headers: {'x-csrf-token': App.settings.csrf_token},
      credentials: 'same-origin',
      method: "delete"
    }).then(response => {
      if(response.ok) {
        json().then(data => {
          App.store.dispatch({type: "TOURNAMENT:INVITE_DESTROYED", data: resp});
        })
      } else {
        console.log("delete invite failed");
      }
    });
  }

}

