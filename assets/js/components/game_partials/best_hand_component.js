import React from "react"
import ReactDOM from "react-dom"

class BestHandComponent extends React.Component {

  resultHand() {
    if(this.props.is_finished) {
      if(this.isWinningHand()) {
        return this.winningHand()
      } else {
        return this.finishedHand()
      }
    } else {
      return this.standardHand()
    }
  }

  isWinningHand() {
   return this.nonWinningStatus().indexOf(this.props.winning_hand) == -1;
  }

  nonWinningStatus(){
    return ["folded", "other_player_folded", "draw"]
  }

  finishedHand() {
    return(
      <span className="standard-hand">
        { App.t(this.props.winning_hand) }
      </span>
    )
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
