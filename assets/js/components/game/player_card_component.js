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
      this.setState({new_card: true});
    } else {
      this.setState({new_card: false});
    }
  }

  classNames() {
    let locked = (this.props.status == "discarded" || this.props.status == "ready") ? "locked" : "";
    let animation_state = "";
    if(this.props.card == "discarded") {
      animation_state = "discarded";
    } else if(this.state.new_card == true) {
      animation_state = "new-card";
    }
    return `card player-card card-${this.props.card} ${this.props.best_card} ${this.props.winner} ${animation_state} ${locked}`;
  }

  cardId() {
   return `player-card-${this.props.index + 1}`;
  }

  discardClicked(e) {
    if(this.props.status != "new") {
      return false;
    }
    let index = e.target.getAttribute("data-card");
    App.store.dispatch({type: "GAME:DISCARD", card_index: index});
  }

  render() {
    let _this = this;
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
