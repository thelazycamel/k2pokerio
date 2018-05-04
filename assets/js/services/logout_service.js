export default class LogoutService {

  constructor(){
    this.url = "/logout";
  }

  call() {
    fetch(this.url,
          { method: 'delete',
            headers: {'x-csrf-token': App.settings.csrf_token},
            credentials: 'same-origin'}
         ).then(function(){
           window.location = "/";
         });
  }


}
