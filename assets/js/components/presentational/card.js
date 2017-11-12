import React from "react"
import ReactDOM from "react-dom"
import {TransitionGroup} from 'react-transition-group'
import {CSSTransition} from 'react-transition-group'

class Card extends React.Component {

  classNames() {
    return `card ${this.props.type}-card card-${this.props.card} ${this.props.best_card} ${this.props.winner} ${this.props.discarded}`;
  }

  cardId() {
   return `${this.props.type}-card-${this.props.index}`;
  }

  render() {
    return (
      <TransitionGroup>
        <CSSTransition
          in={true}
          appear={true}
          enter={true}
          key={this.cardId()}
          classNames={this.cardId() + "-deal"}
          timeout={0} >
          <div className={this.classNames()} data-card={this.props.index} id={this.cardId()} key={this.cardId()}>
            {this.props.card}
          </div>
        </CSSTransition>
      </TransitionGroup>
    )
  }
}

export default Card;
