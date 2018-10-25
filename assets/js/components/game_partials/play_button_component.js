import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class PlayButtonComponent extends React.Component {

  constructor(props) {
    super(props);
  }

  componentDidUpdate(){
    if(this.props.game.disable_button == "timeout"){
      if(this.isFinished()){
        this.timeOutPlayButton(1500);
      } else {
        this.timeOutPlayButton(750);
      }
    }
  }

  playButtonClicked(e) {
    e.preventDefault();
    if(this.props.game.disable_button){
      console.log("disabled");
    } else {
      App.store.dispatch({type: this.messageType()})
    }
  }

  timeOutPlayButton(milliseconds) {
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      App.store.dispatch({type: "GAME:ENABLE_PLAY_BUTTON"})
    }, milliseconds);
  }

  messageType(){
    if(this.props.game.show_bot_request) {
      return "GAME:BOT_REQUEST";
    } else {
      return this.isFinished() ? "GAME:NEXT_GAME" : "GAME:PLAY";
    }
  }

  disabled() {
    if(this.props.game) {
      return this.props.game.disable_button == true || this.props.game.disable_button == "timeout";
    }
  }

  classNames() {
    let names = [];
    if(this.disabled()) {
      names.push("disabled");
    }
    if(this.isFinished()) {
      names.push("next-game");
    } else if(this.isWaiting()){
      names.push("waiting");
    } else if(this.props.game.show_bot_request){
      names.push("bot-request");
    }
    return names.join(" ");
  }

  isWaiting() {
    return (this.waitingForOpponent() || this.waitingForOpponentToPlay()) && !this.props.game.show_bot_request;
  }

  waitingForOpponentToPlay() {
    return (this.props.game.player_status == "ready") ? true : false;
  }

  waitingForOpponent() {
    return this.props.game.status == "standby" ? true : false;
  }

  isFinished() {
    return this.props.game.status == "finished";
  }

  waitingStatusText(){
    if(App.settings.bots == "true") {
      return this.props.game.show_bot_request ? App.t("bot_request") : App.t("searching");
    } else {
     return App.t("waiting");
    }
  }

  playButtonText() {
    if(this.isFinished()) {
      return App.t("next_game");
    } else if(this.waitingForOpponent()){
      return this.waitingStatusText();;
    } else if(this.waitingForOpponentToPlay()) {
      return App.t("waiting");
    } else {
      return App.t("play");
    }
  }

  render() {
    return(
      <Provider store={this.props.store}>
        <a id="play-button" className={this.classNames()} onClick={this.playButtonClicked.bind(this)}>
          {this.playButtonText()}
        </a>
      </Provider>
    );
  }

}

const mapStateToProps = (state) => {
  return {
    game: state.game
  }
}

const ConnectedPlayButtonComponent = connect(mapStateToProps)(PlayButtonComponent)

export default ConnectedPlayButtonComponent;
