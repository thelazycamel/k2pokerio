export default class FriendsController {

  constructor(){
    this.baseUrl = "/friends";
  }

  //TODO: move this to a master class and subclass all controllers
  //
  parameterize(params){
    let esc = encodeURIComponent;
    return Object.keys(params).map(key => {
      return esc(key) + '=' + esc(params[key])
    }).join('&');
  }

  index(params) {
    return (
      fetch(this.baseUrl + "?" + this.parameterize(params),
        {
          headers: {'x-csrf-token': App.settings.csrf_token},
          credentials: 'same-origin'
        }
      ).then(response => { return response.json() })
    )
  }

  create(id) {
    return (
      fetch(this.baseUrl, {
        headers: {'x-csrf-token': App.settings.csrf_token, 'Content-type': 'application/json'},
        credentials: 'same-origin',
        method: 'post',
        body: JSON.stringify({id: id})
      }).then(response => { return response.json() })
    )
  }

  confirm(id) {
    return (
      fetch(`${this.baseUrl}/confirm`, {
        headers: {'x-csrf-token': App.settings.csrf_token, 'Content-type': 'application/json'},
        credentials: 'same-origin',
        method: 'post',
        body: JSON.stringify({id: id})
      }).then(response => { return response.json() })
    )
  }

  status(id) {
    return (
      fetch(`${this.baseUrl}/status/${id}`, {
        headers: {'x-csrf-token': App.settings.csrf_token},
        credentials: 'same-origin'
      }).then(response => { return response.json() })
    )
  }

  destroy(id) {
    return (
      fetch(`${this.baseUrl}/${id}`, {
        headers: {'x-csrf-token': App.settings.csrf_token},
        credentials: 'same-origin',
        method: "delete"
      }).then(response => { return response.json() })
    )
  }

  count(action) {
    return (
      fetch(`${this.baseUrl}/count/${action}`, {
        headers: {'x-csrf-token': App.settings.csrf_token},
        credentials: 'same-origin'
      }).then(response => { return response.json() })
    )
  }

  search(query) {
    return (
      fetch(`${this.baseUrl}/search?${this.parameterize(query)}`, {
        headers: {'x-csrf-token': App.settings.csrf_token, 'Content-type': 'application/json'},
        credentials: 'same-origin',
        method: 'get'
      }).then(response => { return response.json() })
    )
  }

}
