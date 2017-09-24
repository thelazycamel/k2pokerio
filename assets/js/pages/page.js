import socket from "../socket"

class Page {

  constructor(opts) {
    this.setUpPage();
  }

  connectSocket() {
    if(window.userToken != "") {
      App.socket = socket;
      App.socket.connect();
    }
  }

}

export default Page;
