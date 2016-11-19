import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import GameResultComponent from './game_result_component'

class GameComponent extends React.Component {

  currentStatus(){
    let playerStatus = this.props.game.status;
    if(this.props.game.player_status == "ready" && (this.props.game.other_player_status == "new" || this.props.game.other_player_status == "discarded")) {
      playerStatus += " | Waiting for the other Player to play";
    } else if(this.props.game.player_status == "discarded") {
      playerStatus += " | You have discarded, press play to continue";
    } else {
      playerStatus += " | Waiting for you to play";
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

  playButtonClicked() {
    App.store.dispatch({type: "PLAY"});
  }

  foldButtonClicked() {
    App.store.dispatch({type: "FOLD"});
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
        return <div className={"player-card " + card  + bestCardClass }
                    key={"player-card-"+index}
                    data-card={index}
                    onClick={_this.discardClicked}>
                    {card}
                </div>;
      });
      return cards;
    } else {
     return <p>Waitng for players</p>
    }
  }

  renderTableCards() {
    if(this.props.game.table_cards){
      let _this = this;
      let cards = this.props.game.table_cards.map(function(card, index){
        let bestCardClass = _this.props.game.best_cards.includes(card) ? " best-card" : "";
        return <div className={"table-card " + card + bestCardClass}
                    key={"table-card-"+index}
                    data-card={index}>
                    {card}
                </div>;
      });
      return cards;
    } else {
     return <p>Waitng for players</p>
    }
  }

  render() {
    return (<div id="game">
              <div id="opponent-cards"></div>
              <button id="fold-button" onClick={this.foldButtonClicked}>Fold</button>
              <div id="table-cards">{this.renderTableCards()}</div>
              <p>status: {this.currentStatus()}</p>
              <button id="play-button" onClick={this.playButtonClicked}>Play</button>
              <div id="player-cards">{this.renderPlayerCards()}</div>
              <p>{this.props.game.hand_description}</p>
              <div id="game-result-wrapper">{this.showResult()}</div>
            </div>)
  }
}

const mapStateToProps = (state) => {
  return {
    game: state.game,
  }
}

const ConnectedGameComponent = connect(mapStateToProps)(GameComponent)

export default ConnectedGameComponent;
