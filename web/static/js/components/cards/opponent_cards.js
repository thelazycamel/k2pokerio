import React from "react"
import ReactDOM from "react-dom"

class OpponentCards extends React.Component {

  //todo check if game finished and render cards

  //maybe move this to its own component and connect to it from each type: player, table, opponent

  renderCard(card, index) {
  }

  renderCards() {
    if(this.props.waiting) { return };
    let cards = ["opponent-card-1", "opponent-card-2"].map(function(card, index){
      return(
        <div className={ "card opponent-card card-back" }
             key={"opponent-card-" + index}
             id={card}>
        </div>
      )
    });
    return cards;
  }

  render() {
     return(
       <div id="opponent-cards">
         {this.renderCards()}
       </div>
    );
  }

}

export default OpponentCards;
