export default class InvitationsController {

  constructor(){
    this.baseUrl = "/invitations";
  }

  parameterize(params){
    let esc = encodeURIComponent;
    return Object.keys(params).map(key => {
      return esc(key) + '=' + esc(params[key])
    }).join('&');
  }

  count(){
    return (
      fetch(`${this.baseUrl}/count`, {
        headers: {'x-csrf-token': App.settings.csrf_token},
        credentials: 'same-origin',
        method: 'get'
      }).then(response => { return response.json() })
    )
  }

  all(params) {
    return (
      fetch(this.baseUrl + "?" + this.parameterize(params), {
        headers: {'x-csrf-token': App.settings.csrf_token},
        credentials: 'same-origin',
        method: 'get'
      }).then(response => { return response.json() })
    )
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

