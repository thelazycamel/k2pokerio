import React from "react"
import ReactDOM from "react-dom"

class PlayerCard extends React.Component {

  componentDidMount(){
    App.store.dispatch({type: "GAME:ANIMATE_CARD", card_id: this.cardId()});
  }

  componentWillUpdate(nextProps, nextState){
   if(nextProps.card != this.props.card) {
     this.discarded = "discarded";
   } else {
     this.discarded = "";
    }
  }

  classNames() {
    return `card player-card card-${this.props.card} ${this.props.best_card} ${this.props.winner} ${this.discarded}`;
  }

  cardId() {
   return `player-card-${this.props.index + 1}`;
  }

  discardClicked(e) {
    if(this.props.status != "new") {
      return false;
    }
    let index = e.target.getAttribute("data-card");
    e.currentTarget.className += " discarded ";
    App.store.dispatch({type: "GAME:DISCARD", card_index: index});
  }

  render() {
    return (
      <div className={ this.classNames() }
           data-card={this.props.index}
           id={this.cardId()}
           onClick={this.discardClicked.bind(this)}>
           {this.props.card}
      </div>
    )
  }
}

export default PlayerCard;
