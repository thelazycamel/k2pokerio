import React from "react"
import ReactDOM from "react-dom"

class TournamentLoserPopup extends React.Component {

  gotoLobby() {
    window.location = "/tournaments";
  }

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
      <div id="tournament-loser" className="popup">
        <div className="popup-modal-header">
          <h3 className="popup-title">Game Over</h3>
          <button type="button" className="close" onClick={this.gotoLobby}>
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div className="popup-body">
          <div className="popup-image"></div>
          <p>You did not reach the summit!</p>
          <p><span className="username">{this.props.username}</span> has taken all the glory</p>
          <p>All you get is the wooden spoon.</p>
        </div>
        <div className="popup-footer">
           <button type="button" className="btn btn-popup btn-lobby" onClick={this.gotoLobby}>Lobby</button>
        </div>
      </div>
    )
  }
}

export default TournamentLoserPopup;
