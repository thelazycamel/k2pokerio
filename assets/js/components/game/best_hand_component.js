import React from "react"
import ReactDOM from "react-dom"

class BestHandComponent extends React.Component {

  // TODO move this to a util lib, or better still create a translations
  // JSON file
  titlize(word) {
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  }

  // Working now, but needs refactoring
  //

  resultHand() {
    if(this.props.is_finished) {
      let winningHand = this.props.winning_hand;
      if(winningHand){ return (winningHand.split("_").map((word) => { return this.titlize(word)}).join(" "));}
    } else {
      let bestHand = this.props.hand;
      if(bestHand){ return (bestHand.split("_").map((word) => { return this.titlize(word)}).join(" "));}
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
