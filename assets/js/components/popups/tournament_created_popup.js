import React from "react"
import ReactDOM from "react-dom"

class TournamentCreatedPopup extends React.Component {

  gotoLobby() {
    window.location = "/tournaments";
  }

  playTournament() {
  }

  render() {
    return (
      <div id="tournament-created" className="popup">
        <div className="popup-modal-header">
          <h3 className="popup-title">Game Over</h3>
          <button type="button" className="close" onClick={this.gotoLobby}>
            <span aria-hidden="true">&times;</span>
          </button>
        </div>
        <div className="popup-body">
          <div className="popup-image"></div>
          <p>The tournament has been created</p>
          <p>Would you like it now!</p>
        </div>
        <div className="popup-footer">
           <button type="button" className="btn btn-popup btn-lobby" onClick={this.gotoLobby}>Cancel</button>
           <button type="button" className="btn btn-popup btn-again" onClick={this.playTournament}>Play</button>
        </div>
      </div>
    )
  }
}

export default TournamentCreatedPopup;
