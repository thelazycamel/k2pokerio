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

  search(query) {
    fetch(`${this.baseUrl}/search`, {
      headers: {'x-csrf-token': App.settings.csrf_token, 'Content-type': 'application/json'},
      credentials: 'same-origin',
      method: 'get',
      body: {query: query}
    }).done(response => {
      if(response.ok) {
        response.json().then(data => {
          //do something with the search
        })
      } else {
        //do nothing with the search
      }
    });
  }

}
