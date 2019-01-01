import BaseController from './base_controller'

export default class BadgeController extends BaseController {

  constructor(){
    super();
    this.baseUrl = "/badges";
  }

  gold() {
    return (
      fetch(this.baseUrl + "/gold",
        {
          headers: {'x-csrf-token': App.settings.csrf_token},
          credentials: 'same-origin'
        }
      ).then(response => { return response.json() })
    )
  }

}

