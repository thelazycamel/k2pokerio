export default class ProfileImageService {

  constructor(){
    this.url = "/profile/image";
  }

  /* slightly different setup, this returns the whole request and response */
  call(image) {
    return fetch(this.url,
      { method: 'post',
        body: JSON.stringify({image: image}),
        headers: {
          'x-csrf-token': App.settings.csrf_token,
          'content-type': 'application/json'
        },
        credentials: 'same-origin'}
   ).then(response => { return response.json() });
  }


}
