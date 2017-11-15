import React from "react"
import ReactDOM from "react-dom"

class PlayButtonComponent extends React.Component {

  // This doesn't work at the moment, just a template
  // TODO pass in required props in order to render the button as
  // required, Also want to change the bot pop-up to be rendered as the
  // button, this also needs a time out before rendering to stop double clicks
  //
  playButton() {
    if(this.isFinished()) {
      return(<a id="play-button" className="next-game" onClick={this.nextGameButtonClicked}>Next Game</a>);
    } else if(this.waitingForOpponent()){
      let buttonText = App.settings.bots == "true" ? "Searching..." : "Waiting...";
      return(<a id="play-button" className="waiting">{buttonText}</a>);
    } else if(this.waitingForOpponentToPlay()) {
      return(<a id="play-button" className="waiting">Waiting...</a>);
    } else {
      return(<a id="play-button" onClick={this.playButtonClicked}>Play</a>);
    }
  }

  render() {
    <a id="play-button" className="next-game" onClick={this.nextGameButtonClicked}>Next Game</a>
  }

}

export default PlayButtonComponent;
