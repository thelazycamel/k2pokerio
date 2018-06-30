import BaseController from './base_controller'

export default class InvitationsController extends BaseController {

  constructor(){
    super();
    this.baseUrl = "/invitations";
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

}

