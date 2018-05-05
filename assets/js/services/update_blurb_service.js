export default class UpdateBlurbService {

  constructor(){
    this.url = "/profile/blurb";
  }

  /* slightly different setup, this returns the whole request and response */
  call(blurb) {
    return fetch(this.url,
      { method: 'post',
        body: JSON.stringify({blurb: blurb}),
        headers: {
          'x-csrf-token': App.settings.csrf_token,
          'content-type': 'application/json'
        },
        credentials: 'same-origin'}
   ).then(response => { return response.json() });
  }


}
