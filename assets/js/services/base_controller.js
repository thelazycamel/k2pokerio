export default class BaseController {

  parameterize(params){
    let esc = encodeURIComponent;
    return Object.keys(params).map(key => {
      return esc(key) + '=' + esc(params[key])
    }).join('&');
  }

  //all rest actions can be extracted to here

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

  destroy(id) {
    return (
      fetch(`${this.baseUrl}/${id}`, {
        headers: {'x-csrf-token': App.settings.csrf_token},
        credentials: 'same-origin',
        method: "delete"
      }).then(response => { return response.json() })
    )
  }

}
