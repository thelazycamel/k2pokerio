import React from "react"
import ReactDOM from "react-dom"

class Card extends React.Component {

  classNames() {
    return `card ${this.props.type}-card card-${this.props.card} ${this.props.best_card} ${this.props.winner}`;
  }

  cardId() {
   return `${this.props.type}-card-${this.props.index}`;
  }

  render() {
    return (
      <div className={this.classNames()}
        data-card={this.props.index}
        id={this.cardId()}>
          {this.props.card}
        </div>
    )
  }
}

export default Card;
