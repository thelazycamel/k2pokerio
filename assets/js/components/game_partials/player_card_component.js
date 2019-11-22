import React from "react"
import ReactDOM from "react-dom"
import {TransitionGroup} from 'react-transition-group'
import {CSSTransition} from 'react-transition-group'

class PlayerCardComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {};
  }

  componentWillReceiveProps(nextProps){
    if(this.props.card == "discarded"){
      this.setState(state => (
        { ...this.state,
          new_card: true
        }
      ));
    } else {
      this.setState(state => (
        { ...this.state,
          new_card: false
        }
      ));
    }
  }

  lockedCard() {
    if(this.props.status == "discarded" || this.props.status == "ready"){
      return "locked";
    } else {
      return "";
    }
  }

  animationState(){
    if(this.props.card == "discarded") {
      return "discarded";
    } else if(this.state.new_card == true) {
      return "new-card";
    } else {
      return "";
    }
  }

  classNames() {
    let classNames = [
      "card",
      "player-card",
      `card-${this.props.card}`,
      this.bestCardClass(),
      this.winningCardClass(),
      this.animationState(),
      this.lockedCard()
    ];
    return classNames.join(" ");
  }

  winningCardClass(){
    return this.props.winner ? "winner" : "";
  }

  bestCardClass(){
    return this.props.best_card ? "best-card" : "";
  }

  cardId() {
   return `player-card-${this.props.index + 1}`;
  }

  discardClicked(e) {
    if(this.props.status != "new") { return false }
    let index = e.target.getAttribute("data-card");
    App.store.dispatch({type: "GAME:DISCARD", card_index: index});
  }

  render() {
    return (
      <TransitionGroup>
        <CSSTransition
          appear
          enter={false}
          exit={false}
          key={this.cardId()}
          classNames={this.cardId() + "-deal"}
          timeout={1000}>
          <div className={ this.classNames() }
               data-card={this.props.index}
               id={this.cardId()}
               onClick={this.discardClicked.bind(this)}>
               {this.props.card}
          </div>
        </CSSTransition>
      </TransitionGroup>
    )
  }
}

export default PlayerCardComponent;
