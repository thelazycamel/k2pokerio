import socket from "../socket"

class Page {

  constructor(opts) {
    this.setUpPage();
    this.setUpEventGlobalListeners();
  }

  connectSocket() {
    if(window.userToken != "") {
      App.socket = socket;
      App.socket.connect();
    }
  }

  //TODO move the alert boxes to a react component for self destruction
  setUpEventGlobalListeners() {
    let closeAlert = document.getElementsByClassName("close")[0];
    if(closeAlert){
      closeAlert.onclick =  function() {
        let alert = document.getElementsByClassName("alert")[0];
        if(alert){
          alert.parentNode.removeChild(alert);
        }
      }
    }
    window.setTimeout(function(){
      let alert = document.getElementsByClassName("alert")[0];
      if(alert) {
        alert.parentNode.removeChild(alert);
      }
    }, 5000);
  }

}

export default Page;
