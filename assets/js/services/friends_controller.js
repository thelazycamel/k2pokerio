import BaseController from './base_controller'

export default class FriendsController extends BaseController {

  constructor(){
    super();
    this.baseUrl = "/friends";
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

  friendsOnly(query) {
    return (
      fetch(`${this.baseUrl}/friends_only?${this.parameterize(query)}`, {
        headers: {'x-csrf-token': App.settings.csrf_token, 'Content-type': 'application/json'},
        credentials: 'same-origin',
        method: 'get'
      }).then(response => { return response.json() })
    )
  }

}
