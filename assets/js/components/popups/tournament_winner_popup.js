import React from "react"
import ReactDOM from "react-dom"

class TournamentWinnerPopup extends React.Component {

  render() {
    return (
      <div className="popup" id="tournament-winner">
        <h1>Congratulations</h1>
        <p>You have won the tournament!</p>
      </div>
    )
  }
}

export default TournamentWinnerPopup;
