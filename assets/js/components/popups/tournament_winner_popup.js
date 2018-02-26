import React from "react"
import ReactDOM from "react-dom"

class TournamentWinnerPopup extends React.Component {

  gotoLobby() {
    window.location = "/tournaments";
  }

  //TODO set up play again on a duel where it will create
  // another duel with the same person
  playAgain() {
    App.store.dispatch({type: "TOURNAMENT:PLAY_AGAIN"});
  }

  playAgainButton(){
    if(this.props.type == "duel") {
      return(
        <button type="button" className="btn btn-popup btn-again" onClick={this.playAgain}>Play Again</button>
      )
    }
  }

  render() {
    return (
      <div id="tournament-winner" className="popup">
        <div className="popup-modal-header">
          <h3 className="popup-title">Summit Reached!</h3>
          <button type="button" className="close" onClick={this.gotoLobby}>
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div className="popup-body">
          <div className="popup-image"></div>
          <p>Congratulations {this.props.username}</p>
          <p>You have won the {this.props.type}</p>
        </div>
        <div className="popup-footer">
           <button type="button" className="btn btn-popup btn-lobby" onClick={this.gotoLobby}>Lobby</button>
        </div>
      </div>
    )
  }
}


export default TournamentWinnerPopup;
