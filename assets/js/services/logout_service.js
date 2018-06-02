export default class LogoutService {

  constructor(){
    this.baseUrl = "/logout";
  }

  call() {
    fetch(this.baseUrl, { 
      method: 'delete',
      headers: {'x-csrf-token': App.settings.csrf_token},
      credentials: 'same-origin'
    }).then(()=> { window.location = "/";});
  }

}
