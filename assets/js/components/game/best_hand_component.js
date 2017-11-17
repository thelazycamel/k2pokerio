import React from "react"
import ReactDOM from "react-dom"

class BestHandComponent extends React.Component {

  resultHand() {
    if(this.props.is_finished) {
      let winningHand = this.props.winning_hand;
      if(winningHand) { return(App.t(winningHand)) }
    } else {
      let bestHand = this.props.hand;
      if(bestHand) { return(App.t(bestHand)) }
    }
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
