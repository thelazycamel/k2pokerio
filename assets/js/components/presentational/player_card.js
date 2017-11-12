import React from "react"
import ReactDOM from "react-dom"
import TransitionGroup from 'react-transition-group/TransitionGroup'

class PlayerCard extends React.Component {

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
    let discarded = "";
    if(this.props.card == "discarded") {
      discarded = "discarded";
    } else if(this.state.new_card == true) {
      discarded = "new-card";
    }
    return `card player-card card-${this.props.card} ${this.props.best_card} ${this.props.winner} ${discarded}`;
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
    return (
      <TransitionGroup transitionName={this.cardId() + "-deal"} transitionAppear={true} transitionAppearTimeout={0} transitionEnter={false} transitionLeave={false}>
        <div className={ this.classNames() }
             data-card={this.props.index}
             id={this.cardId()}
             onClick={this.discardClicked.bind(this)}>
             {this.props.card}
        </div>
      </TransitionGroup>
    )
  }
}

export default PlayerCard;
