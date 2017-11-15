import React from "react"
import ReactDOM from "react-dom"

class BestHandComponent extends React.Component {

  // DIRECT COPY OF GameComponent code, needs building

  // TODO extract out to a separate component and tidy up
  // think about abstracting this text out to a translator
  // and shorten this long function
  renderBestHand() {
    if(this.isFinished()) {
      let winningHand = this.props.game.result.win_description;
      if(!winningHand){return};
      let humanizedWinningHand = winningHand.split("_").map((word) => { return this.titlize(word)}).join(" ");
      return ( <div id="best-hand"><span className="result-hand">{humanizedWinningHand}</span></div>);
    } else {
      let bestHand = this.props.game.hand_description;
      if(!bestHand){return};
      let humanizedBestHand = bestHand.split("_").map((word) => { return this.titlize(word)}).join(" ");
      return ( <div id="best-hand">Best Hand<br/>{humanizedBestHand}</div>);
    }
  }

  render() {

  }

}

export default BestHandComponent;
