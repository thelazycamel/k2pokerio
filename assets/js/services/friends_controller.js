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
    fetch(this.baseUrl, {
      headers: {'x-csrf-token': App.settings.csrf_token, 'Content-type': 'application/json'},
      credentials: 'same-origin',
      method: 'post',
      body: {id: id}
    }).done(response => {
      if(response.ok){
        response.json().then(data => {
          App.store.dispatch({type: "OPPONENT_PROFILE:REQUESTED", resp: data});
        })
      } else {
        App.store.dispatch({type: "OPPONENT_PROFILE:REQUESTED", resp: {friend: "na"}});
      }
    })
  }

  confirm(id) {
    fetch(`${this.baseUrl}/confirm`, {
      headers: {'x-csrf-token': App.settings.csrf_token, 'Content-type': 'application/json'},
      credentials: 'same-origin',
      method: 'post',
      body: {id: id}
    }).done(response => {
      if(response.ok) {
        response.json().then(data => {
          App.store.dispatch({type: "OPPONENT_PROFILE:CONFIRMED", resp: response});
        })
      } else {
        App.store.dispatch({type: "OPPONENT_PROFILE:CONFIRMED", resp: {friend: "na"}});
      }
    });
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
