import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import GameResultComponent from './game_result_component'
import OpponentCards from './cards/opponent_cards'

class GameComponent extends React.Component {

  waitingForOpponent() {
    return this.props.game.status == "standby" ? true : false;
  }

  currentStatus(){
    console.log(this.waitingForOpponent());
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

  showResult() {
    if(this.props.game.status == "finished") {
      return (<GameResultComponent result={this.props.game.result}/>)
    } else {
      return "";
    }
  }

  playButtonClicked(e) {
    e.preventDefault();
    App.store.dispatch({type: "PLAY"});
  }

  foldButtonClicked() {
    App.store.dispatch({type: "FOLD"});
    return false;
  }

  discardClicked(e) {
    let index = e.target.getAttribute("data-card");
    App.store.dispatch({type: "DISCARD", card_index: index})
  }

  /* consider moving this to its own component */
  renderPlayerCards() {

    if(this.props.game.cards){
      let _this = this;
      let cards = this.props.game.cards.map(function(card, index){
        let bestCardClass = _this.props.game.best_cards.includes(card) ? " best-card" : "";
        return <div className={"card player-card " + "card-"+ card  + bestCardClass }
                    key={"player-card-"+index}
                    data-card={index}
                    id={ "player-card-" + (index + 1) }
                    onClick={_this.discardClicked}>
                    {card}
                </div>;
      });
      return cards;
    }
  }

  renderTableCards() {
    if(this.props.game.table_cards){
      let _this = this;
      let cards = this.props.game.table_cards.map(function(card, index){
        let bestCardClass = _this.props.game.best_cards.includes(card) ? " best-card" : "";
        return <div className={"card table-card " + "card-" + card + bestCardClass}
                    key={"table-card-"+index}
                    data-card={index}
                    id={"table-card-"+(index+1)}>
                    {card}
                </div>;
      });
      return cards;
    }
  }

  renderOpponentCards() {
    let waiting = this.waitingForOpponent();
    return (
      <OpponentCards waiting={waiting} result={this.props.game.result} />
    )
  }

  /* TODO: Fix game result */

  render() {
    let waiting = this.waitingForOpponent();
    return (<Provider store={this.props.store}>
              <div id="game">
                <div id="shine"></div>
                { this.renderOpponentCards() }
                <a id="fold-button" onClick={this.foldButtonClicked}>Fold</a>
                <div id="table-cards">{this.renderTableCards()}</div>
                <div id="game-status">{this.currentStatus()}</div>
                <a id="play-button" onClick={this.playButtonClicked}>Play</a>
                <div id="player-cards">{this.renderPlayerCards()}</div>
                <div id="best-hand">Best Hand<br/>{this.props.game.hand_description}</div>
                <div id="game-result-wrapper">{this.showResult()}</div>
              </div>
           </Provider>)
  }
}

const mapStateToProps = (state) => {
  return {
    game: state.game,
  }
}

const ConnectedGameComponent = connect(mapStateToProps)(GameComponent)

export default ConnectedGameComponent;
