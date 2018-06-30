import BaseController from './base_controller'

export default class ProfileController extends BaseController {

  constructor(){
    super();
    this.baseUrl = "/profile";
  }

  update_image(image) {
    return fetch(`${this.baseUrl}/update_image`,
      { method: 'post',
        body: JSON.stringify({image: image}),
        headers: {
          'x-csrf-token': App.settings.csrf_token,
          'content-type': 'application/json'
        },
        credentials: 'same-origin'}
   ).then(response => { return response.json() });
  }

  update_blurb(blurb) {
    return fetch(`${this.baseUrl}/update_blurb`,
      { method: 'post',
        body: JSON.stringify({blurb: blurb}),
        headers: {
          'x-csrf-token': App.settings.csrf_token,
          'content-type': 'application/json'
        },
        credentials: 'same-origin'}
    ).then(response => { return response.json() });
  }

  update_password(passwords) {
    return fetch(`${this.baseUrl}/update_password`,
      { method: 'post',
        body: JSON.stringify({passwords: passwords}),
        headers: {
          'x-csrf-token': App.settings.csrf_token,
          'content-type': 'application/json'
        },
        credentials: 'same-origin'}
    ).then(response => { return response.json() });
  }

}
