export default class UpdatePasswordService {

  constructor(){
    this.url = "/profile/update_password";
  }

  /* slightly different setup, this returns the whole request and response */
  call(passwords) {
    return fetch(this.url,
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
