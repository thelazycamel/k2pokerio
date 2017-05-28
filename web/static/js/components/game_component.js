import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Card from './presentational/card'
import Scoreboard from './presentational/scoreboard'
import PlayerCard from './presentational/player_card'

class GameComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {};
  }

  componentWillReceiveProps(nextProps){
    if(nextProps.game.other_player_status == "discarded" && this.props.game.other_player_status != "discarded"){
      console.log(nextProps.game.other_player_status, this.props.game.other_player_status)
      this.setState({opponent_discarded: true});
    } else {
      this.setState({opponent_discarded: false});
    }
  }

  waitingForOpponent() {
    return this.props.game.status == "standby" ? true : false;
  }

  waitingForOpponentToPlay() {
    return this.props.game.player_status == "ready" ? true : false;
  }

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

  isAWinningCard(card) {
    if(this.props.game.status == "finished" && this.props.game.result.winning_cards.includes(card)) {
      return "winner";
    } else {
      return "";
    }
  }

  renderPlayerCards() {
    if(this.props.game.cards){
      let cards = this.props.game.cards.map((card, index) => {
        let bestCardClass = this.props.game.best_cards.includes(card) ? "best-card" : "";
        let winningCardClass = this.isAWinningCard(card);
        return <PlayerCard card={card} index={index} best_card={bestCardClass} key={index} winner={winningCardClass} status={this.props.game.player_status} />
      });
      return cards;
    }
  }

  renderTableCards() {
    if(this.props.game.table_cards){
      let cards = this.props.game.table_cards.map((card, index) => {
        let bestCard = this.props.game.best_cards.includes(card) ? " best-card" : "";
        let winningCardClass = this.isAWinningCard(card);
        return <Card card={card} index={index+1} best_card={bestCard} type="table" key={index} winner={winningCardClass} discarded="" />
      });
      return cards;
    }
  }

  // TODO all this changing discarded state should be set in K2poker
  // and not dealt with here, this should just be the presentational layer
  opponentDiscarded() {
    let discards = ["",""];
    if(this.state.opponent_discarded) {
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
      let winningCardClass = this.isAWinningCard(card);
      return <Card card={card} index={index+1} best_card="" type="opponent" key={index} winner={winningCardClass} discarded={discarded[index]} />
    });
    return cards;
  }

  opponentCards() {
    if(this.props.game.result && this.props.game.result.other_player_cards.length == 2) {
     return this.props.game.result.other_player_cards;
    } else {
      return ["back","back"];
    }
  }

  isFinished() {
    return this.props.game.status == "finished";
  }

  resultClassName() {
    return this.isFinished() ? "result" : "";
  }

  foldButton() {
    if(!this.isFinished() && !this.waitingForOpponent()) {
      return (<a id="fold-button" onClick={this.foldButtonClicked}>Fold</a>);
    }
  }

  playButton() {
    if(this.isFinished()) {
      return(<a id="play-button" className="next-game" onClick={this.nextGameButtonClicked}>Next Game</a>);
    } else if(this.waitingForOpponent() || this.waitingForOpponentToPlay()) {
      return(<a id="play-button" className="waiting">Waiting...</a>);
    } else {
      return(<a id="play-button" onClick={this.playButtonClicked}>Play</a>);
    }
  }

  renderStatus() {
    if(this.isFinished()) {
      let status = this.props.game.player_status
      return( <span className={`${status}-status`}>You {this.titlize(status)}</span> );
    } else {
      return this.currentStatus();
    }
  }

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

  titlize(word) {
    return word.charAt(0).toUpperCase() + word.slice(1).toLowerCase();
  }

  openOpponentProfile(e) {
    e.preventDefault();
    App.pageComponentManager.linkClicked("profile");
  }

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
              { this.renderBestHand() }
              <Scoreboard current_score = {this.props.player.current_score} />
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
