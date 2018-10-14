import React from "react"
import ReactDOM from "react-dom"

class BestHandComponent extends React.Component {

  resultHand() {
    if(this.props.is_finished) {
      if(this.isWinningHand()) {
        return this.winningHand()
      } else {
        return this.standardHand()
      }
    } else {
      return this.standardHand()
    }
  }

  isWinningHand() {
   return this.props.winning_hand.indexOf(this.nonWinningStatus()) == -1;
  }

  nonWinningStatus(){
    return ["folded", "other_player_folded", "draw"]
  }

  standardHand() {
    return(
      <span className="standard-hand">
        { App.t(this.props.hand) }
      </span>
    )
  }

  winningHand() {
    return(
      <span className="final-hand">
        { App.t(this.props.winning_hand) }
        <br/>{ App.t("beats") }<br/>
        { App.t(this.props.losing_hand) }
      </span>
    )
  }

  render() {
    return (
      <div id="best-hand">
        <span className="result-hand">
          { this.resultHand() }
        </span>
      </div>
    )
  }

}

export default BestHandComponent;
