import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Card from './presentational/card'

class GameComponent extends React.Component {

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

  discardClicked(e) {
    let index = e.target.getAttribute("data-card");
    App.store.dispatch({type: "GAME:DISCARD", card_index: index})
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
        return <div className={`card player-card card-${card} ${bestCardClass} ${winningCardClass}` }
                    key={`player-card-${index}`}
                    data-card={index}
                    id={`player-card-${index + 1}`}
                    onClick={this.discardClicked}>
                    {card}
                </div>;
      });
      return cards;
    }
  }

  renderTableCards() {
    if(this.props.game.table_cards){
      let cards = this.props.game.table_cards.map((card, index) => {
        let bestCard = this.props.game.best_cards.includes(card) ? " best-card" : "";
        let winningCardClass = this.isAWinningCard(card);
        return <Card card={card} index={index+1} best_card={bestCard} type="table" key={index} winner={winningCardClass} />
      });
      return cards;
    }
  }

  renderOpponentCards() {
    if(this.waitingForOpponent()) { return };
    let cards = this.opponentCards().map((card, index) => {
      let winningCardClass = this.isAWinningCard(card);
      return <Card card={card} index={index+1} best_card="" type="opponent" key={index} winner={winningCardClass} />
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
    if(!this.isFinished()) {
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

  render() {
    return (
      <Provider store={this.props.store}>
       <div id="game-root">
          <div id="game" className={this.resultClassName()} >
            <div id="shine"></div>
            <div id="opponent-cards">{this.renderOpponentCards()}</div>
            { this.foldButton() }
            <div id="table-cards">{this.renderTableCards()}</div>
            <div id="game-status">{this.renderStatus()}</div>
            { this.playButton() }
            <div id="player-cards">{this.renderPlayerCards()}</div>
            { this.renderBestHand() }
          </div>
        </div>
      </Provider>
     )
  }
}

const mapStateToProps = (state) => {
  return {
    game: state.game
  }
}

const ConnectedGameComponent = connect(mapStateToProps)(GameComponent)

export default ConnectedGameComponent;
