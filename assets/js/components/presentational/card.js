import React from "react"
import ReactDOM from "react-dom"
import TransitionGroup from 'react-transition-group/TransitionGroup'

class Card extends React.Component {

  classNames() {
    return `card ${this.props.type}-card card-${this.props.card} ${this.props.best_card} ${this.props.winner} ${this.props.discarded}`;
  }

  cardId() {
   return `${this.props.type}-card-${this.props.index}`;
  }

  render() {
    return (
      <TransitionGroup transitionName={this.cardId() + "-deal"} transitionAppear={true} transitionAppearTimeout={0} transitionEnter={false} transitionLeave={false}>
        <div className={this.classNames()} data-card={this.props.index} id={this.cardId()} key={this.cardId()}>
          {this.props.card}
        </div>
      </TransitionGroup>
    )
  }
}

export default Card;
