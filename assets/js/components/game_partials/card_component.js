import React from "react"
import ReactDOM from "react-dom"
import {TransitionGroup} from 'react-transition-group'
import {CSSTransition} from 'react-transition-group'

class CardComponent extends React.Component {

  classNames() {
    let classes = [
      "card",
      this.props.type + "-card",
      "card-" + this.props.card,
      this.bestCardClass(),
      this.winningCardClass(),
      this.props.discarded
    ]
    return classes.join(" ");
  }

  winningCardClass(){
    return this.props.winner ? "winner" : "";
  }

  bestCardClass(){
    return this.props.best_card ? "best-card" : "";
  }

  cardId() {
   return `${this.props.type}-card-${this.props.index}`;
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
          timeout={1000} >
          <div className={this.classNames()} data-card={this.props.index} id={this.cardId()} key={this.cardId()}>
            {this.props.card}
          </div>
        </CSSTransition>
      </TransitionGroup>
    )
  }
}

export default CardComponent;
