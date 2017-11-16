import React from "react"
import ReactDOM from "react-dom"

class GameStatusComponent extends React.Component {

  // DIRECT COPY OF GameComponent code, needs building

  // TODO maybe move this out to another component and tidy up
  currentStatus(){
    if(this.waitingForOpponent()) {return this.props.game.status};
    let playerStatus = "";
    switch(this.props.game.player_status) {
      case "ready":
        playerStatus = "Waiting on your opponent";
        break;
      case "discarded":
        playerStatus = "Discarded, press play";
        break;
      default:
        playerStatus = "Waiting for you to play";
    }
    return playerStatus;
  }

  //TODO probably better to move this out to another component and make it nicer
  //
  renderStatus() {
    if(this.isFinished()) {
      let status = this.props.game.player_status
      return( <span className={`${status}-status`}>You {this.titlize(status)}</span> );
    } else {
      return this.currentStatus();
    }
  }

  render() {

  }

}

export default GameStatusComponent;
