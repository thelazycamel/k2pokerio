import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'

class GameComponent extends React.Component {

  currentStatus(){
    let playerStatus = this.props.game.status;
    if(this.props.game.player_status == "ready" && this.props.game.other_player_status == "new") {
      playerStatus += " | Waiting for the other Player to play";
    } else if(this.props.game.player_status == "discarded") {
      playerStatus += " | You have discarded, press play to continue";
    } else {
      playerStatus += " | Waiting for you to play";
    }
    return playerStatus;
  }

  playButtonClicked() {
    App.store.dispatch({type: "PLAY"});
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
        return <div className={"player-card " + card}
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
        return <div className={"table-card " + card}
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
              <div id="table-cards">{this.renderTableCards()}</div>
              <p>status: {this.currentStatus()}</p>
              <div id="player-cards">{this.renderPlayerCards()}</div>
              <button id="play-button" onClick={this.playButtonClicked}>Play</button>
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
