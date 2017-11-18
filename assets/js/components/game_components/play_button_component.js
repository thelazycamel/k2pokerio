import React from "react"
import ReactDOM from "react-dom"

class PlayButtonComponent extends React.Component {

  playButtonClicked(e) {
    e.preventDefault();
    App.store.dispatch({type: this.messageType()})
  }

  messageType(){
    return this.props.finished ? "GAME:NEXT_GAME" : "GAME:PLAY";
  }

  classNames() {
    let names = [];
    if(this.props.finished) {
      names.push("next-game");
    } else if(this.isWaiting()){
      names.push("waiting");
    }
    return names.join(" ");
  }

  isWaiting(){
    return (this.props.waiting || this.props.opponent_turn) ? true : false;
  }

  playButtonText() {
    if(this.props.finished) {
      return App.t("Next Game");
    } else if(this.props.waiting){
      return App.settings.bots == "true" ? App.t("searching") : App.t("waiting");
    } else if(this.props.opponent_turn) {
      return App.t("waiting");
    } else {
      return App.t("play");
    }
  }

  render() {
    return(
      <a id="play-button" className={this.classNames()} onClick={this.playButtonClicked.bind(this)}>
        {this.playButtonText()}
      </a>
    );
  }

}

export default PlayButtonComponent;
