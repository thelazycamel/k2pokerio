import {Socket} from "phoenix"

class Tournament {

  constructor(socket){
    let element = document.getElementById("tournament-graph");
    let id = element.getAttribute("data-tournament");
    if(!element || !id) { return; }
    let tournamentChannel = socket.channel("tournament:" + id);
    if(tournamentChannel) {
      console.log(`initialized the socket channel for Tournament: ${id}`);
      this.showStuff(socket, element);
    } else {
      console.log("oh no something went wrong!")
    }
  }

  showStuff(socket, element) {
    console.log(socket);
    console.log(element);
  }

};

export default Tournament;
