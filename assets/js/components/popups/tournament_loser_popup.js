import React from "react"
import ReactDOM from "react-dom"

class TournamentLoserPopup extends React.Component {

  render() {
    return (
      <div className="popup" id="tournament-winner">
        <h1>Oh No!</h1>
        <p>Its all over, you have lost</p>
      </div>
    )
  }
}

export default TournamentLoserPopup;
