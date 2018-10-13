import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class PlayButtonComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {disabled: false};
  }

  playButtonClicked(e) {
    e.preventDefault();
    if(this.state.disabled){
      console.log("disabled");
    } else {
      App.store.dispatch({type: this.messageType()})
      this.timeOutPlayButton()
    }
  }

  timeOutPlayButton() {
    this.setState({disabled: true});
    clearTimeout(this.timeout);
    this.timeout = setTimeout(() => {
      this.setState({disabled: false})
    }, 500);
  }

  messageType(){
    if(this.props.game.show_bot_request) {
      return "GAME:BOT_REQUEST";
    } else {
      return this.isFinished() ? "GAME:NEXT_GAME" : "GAME:PLAY";
    }
  }

  classNames() {
    let names = [];
    if(this.state.disabled) {
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
