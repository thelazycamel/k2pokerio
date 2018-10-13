import React from "react"
import ReactDOM from "react-dom"

class BestHandComponent extends React.Component {

  resultHand() {
    if(this.props.is_finished) {
      let winningHand = this.props.winning_hand;
      return(App.t(winningHand));
    } else {
      return(App.t(this.props.hand));
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
