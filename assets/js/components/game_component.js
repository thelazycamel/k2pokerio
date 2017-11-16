import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Scoreboard from './presentational/scoreboard'
import PlayerCardComponent from './game/player_card_component'
import CardComponent from './game/card_component'
import BestHandComponent from './game/best_hand_component'
import PlayButtonComponent from './game/play_button_component'
import GameStatusComponent from './game/game_status_component'

class GameComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {};
  }

  componentWillReceiveProps(nextProps){
    this.setOpponentDiscardedAnimation(nextProps);
  }

  setOpponentDiscardedAnimation(nextProps){
    if(nextProps.game.other_player_status == "discarded" && this.props.game.other_player_status != "discarded"){
      this.setState({opponent_discarded_animation: true});
    } else {
      this.setState({opponent_discarded_animation: false});
    }
  }

  waitingForOpponent() {
    return this.props.game.status == "standby" ? true : false;
  }

  waitingForOpponentToPlay() {
    return (this.props.game.player_status == "ready") ? true : false;
  }

  // TODO maybe move this out to another component and tidy up
  currentStatus(){
    if(this.waitingForOpponent()) {return this.props.game.status};
    let playerStatus = "";
    switch(this.props.game.player_status) {
      case "ready":
        playerStatus = "Waiting on your opponent";
        break;
      case "discarded":
        playerStatus = "Discarded, press play";
        break;
      default:
        playerStatus = "Waiting for you to play";
    }
    return playerStatus;
  }

  playButtonClicked(e) {
    e.preventDefault();
    App.store.dispatch({type: "GAME:PLAY"});
  }

  foldButtonClicked() {
    App.store.dispatch({type: "GAME:FOLD"});
    return false;
  }

  nextGameButtonClicked() {
    App.store.dispatch({type: "GAME:NEXT_GAME"})
  }

  renderPlayerCards() {
    if(this.props.game.cards){
      let cards = this.props.game.cards.map((card, index) => {
        return <PlayerCardComponent
                  card={card}
                  index={index}
                  best_card={this.bestCardClass(card)}
                  key={index}
                  winner={this.isAWinningCard(card)}
                  status={this.props.game.player_status} />
      });
      return cards;
    }
  }

  bestCardClass(card) {
    return this.props.game.best_cards.includes(card) ? "best-card" : "";
  }

  isAWinningCard(card) {
    if(this.props.game.status == "finished" && this.props.game.result.winning_cards.includes(card)) {
      return "winner";
    } else {
      return "";
    }
  }

  renderTableCards() {
    if(this.props.game.table_cards){
      let cards = this.props.game.table_cards.map((card, index) => {
        return <CardComponent
                  card={card}
                  index={index+1}
                  best_card={this.bestCardClass(card)}
                  type="table"
                  key={index}
                  winner={this.isAWinningCard(card)}
                  discarded="" />
      });
      return cards;
    }
  }

  opponentDiscarded() {
    let discards = ["",""];
    if(this.state.opponent_discarded_animation) {
      if(this.props.game.status == "river") {
        discards = ["discarded", "discarded"];
      } else {
        let index = Math.floor((Math.random() * 2));
        discards[index] = "discarded";
      }
    }
    return discards;
  }

  renderOpponentCards() {
    if(this.waitingForOpponent()) { return };
    let discarded = this.opponentDiscarded();
    let cards = this.opponentCards().map((card, index) => {
      return <CardComponent
                card={card}
                index={index+1}
                best_card=""
                type="opponent"
                key={index}
                winner={this.isAWinningCard(card)}
                discarded={discarded[index]} />
    });
    return cards;
  }

  opponentCards() {
    if(this.canShowOpponentCards()) {
     return this.props.game.result.other_player_cards;
    } else {
      return ["back","back"];
    }
  }

  canShowOpponentCards() {
    return (this.props.game.result && this.props.game.result.other_player_cards.length == 2)
  }

  isFinished() {
    return this.props.game.status == "finished";
  }

  resultClassName() {
    return this.isFinished() ? "result" : "";
  }

  foldButton() {
    if(this.displayFoldButton()) {
      return (<a id="fold-button" onClick={this.foldButtonClicked}>Fold</a>);
    }
  }

  displayFoldButton() {
   return (!this.isFinished() && !this.waitingForOpponent())
  }

  //TODO move the play button to a new component
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

  //TODO probably better to move this out to another component and make it nicer
  //
  renderStatus() {
    if(this.isFinished()) {
      let status = this.props.game.player_status
      return( <span className={`${status}-status`}>You {this.titlize(status)}</span> );
    } else {
      return this.currentStatus();
    }
  }

  titlize(word) {
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  }

  openOpponentProfile(e) {
    e.preventDefault();
    App.pageComponentManager.linkClicked("profile");
  }

  //TODO move this to a separate component
  renderOpponentImage(){
    if (this.waitingForOpponent()) { return;}
    if(this.props.opponent_profile && this.props.opponent_profile.image) {
      return (
        <a id="opponent-image" onClick={this.openOpponentProfile.bind(this)}>
          <img src= {"/images/profile-images/" +this.props.opponent_profile.image} alt={this.props.opponent_profile.username}/>
          <div id="opponent-name">{this.props.opponent_profile.username }</div>
        </a>
      )
    }
  }

  winDescription(){
    if(this.props.game.result){
      return this.props.game.result.win_description;
    }
  }

  render() {
    return (
      <Provider store={this.props.store}>
        <div id="game-root" className={this.props.page.tabs["game"]}>
          <div id="game-inner">
            <div id="game" className={this.resultClassName()} >
              <div id="shine"></div>
              {this.renderOpponentImage()}
              <div id="opponent-cards">{this.renderOpponentCards()}</div>
              { this.foldButton() }
              <div id="table-cards">{this.renderTableCards()}</div>
              <div id="game-status">{this.renderStatus()}</div>
              { this.playButton() }
              <div id="player-cards">{this.renderPlayerCards()}</div>
              <BestHandComponent is_finished={this.isFinished()} winning_hand={this.winDescription()} hand={this.props.game.hand_description} />
              <Scoreboard current_score={this.props.player.current_score} />
            </div>
          </div>
        </div>
      </Provider>
     )
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page,
    game: state.game,
    player: state.player,
    opponent_profile: state.opponent_profile
  }
}

const ConnectedGameComponent = connect(mapStateToProps)(GameComponent)

export default ConnectedGameComponent;
