import React from "react"
import ReactDOM from "react-dom"

class GameResultComponent extends React.Component {

  tableCards() {
    let _this = this;
    let cards = this.props.result.table_cards.map(function(card, index){
      let bestCardClass = _this.props.result.winning_cards.includes(card) ? " best-card" : "";
      return <div className={"table-result-card " + card + bestCardClass} key={"table-result-card-"+index}>
               {card}
             </div>;
    });
    return cards;
  }

  otherPlayerCards() {
    let _this = this;
    let lose = this.props.result.status == "lose" || this.props.result.status == "draw";
    let cards = this.props.result.other_player_cards.map(function(card, index){
      let bestCardClass = (lose && _this.props.result.winning_cards.includes(card)) ? " best-card" : "";
      return <div className={"other-player-card " + card + bestCardClass} key={"other-player-card-"+index}>
               {card}
             </div>;
    });
    return cards;

  }

  playerCards() {
    let _this = this;
    let win = this.props.result.status == "win" || this.props.result.status == "draw";
    let cards = this.props.result.player_cards.map(function(card, index){
      let bestCardClass = (win && _this.props.result.winning_cards.includes(card)) ? " best-card" : "";
      return <div className={"player-result-card " + card + bestCardClass} key={"player-result-card-"+index}>
               {card}
             </div>;
    });
    return cards;

  }

  nextGameButtonClicked() {
    App.store.dispatch({type: "NEXT_GAME"})
  }

  render() {
    return (
      <div id="game-result">
        <p className="result-status">You {this.props.result.status}</p>
        <button id="next-game" onClick={this.nextGameButtonClicked}>Next Game</button>
        <p>{this.props.result.win_description} beats {this.props.result.lose_description}</p>
        <div id="other-player-cards">Other Player Cards: {this.otherPlayerCards()}</div>
        <div id="table-result-cards">Table Cards: {this.tableCards()}</div>
        <div id="player-result-cards">Your Cards: {this.playerCards()}</div>
      </div>

    )
  }

}

export default GameResultComponent;
