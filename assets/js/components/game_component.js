import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Scoreboard from './shared_partials/scoreboard'
import PlayerCardComponent from './game_partials/player_card_component'
import CardComponent from './game_partials/card_component'
import BestHandComponent from './game_partials/best_hand_component'
import PlayButtonComponent from './game_partials/play_button_component'
import GameStatusComponent from './game_partials/game_status_component'
import OpponentProfileImageComponent from './game_partials/opponent_profile_image_component'

class GameComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {};
  }

  componentWillReceiveProps(nextProps){
    this.setOpponentDiscardedAnimation(nextProps);
  }

  setOpponentDiscardedAnimation(nextProps){
    if(nextProps.game.other_player_status == "discarded" && this.props.game.other_player_status != "discarded"){
      this.setState({opponent_discarded_animation: true});
    } else {
      this.setState({opponent_discarded_animation: false});
    }
  }

  waitingForOpponent() {
    return this.props.game.status == "standby" ? true : false;
  }

  waitingForOpponentToPlay() {
    return (this.props.game.player_status == "ready") ? true : false;
  }

  foldButtonClicked(e) {
    e.target.setAttribute("disabled", "disabled");
    App.store.dispatch({type: "GAME:FOLD"});
    return false;
  }

  renderPlayerCards() {
    if(this.props.game.cards){
      let cards = this.props.game.cards.map((card, index) => {
        return <PlayerCardComponent
                  card={card}
                  index={index}
                  best_card={this.isBestCard(card)}
                  key={index}
                  winner={this.isAWinningCard(card)}
                  status={this.props.game.player_status} />
      });
      return cards;
    }
  }

  isBestCard(card) {
    return this.props.game.best_cards.includes(card) ? true : false;
  }

  isAWinningCard(card) {
    return (this.props.game.status == "finished" && this.props.game.result.winning_cards.includes(card))
  }

  renderTableCards() {
    if(this.props.game.table_cards){
      let cards = this.props.game.table_cards.map((card, index) => {
        return <CardComponent
                  card={card}
                  index={index+1}
                  best_card={this.isBestCard(card)}
                  type="table"
                  key={index}
                  winner={this.isAWinningCard(card)}
                  discarded="" />
      });
      return cards;
    }
  }

  opponentDiscarded() {
    let discards = ["",""];
    if(this.state.opponent_discarded_animation) {
      if(this.props.game.status == "river") {
        discards = ["discarded", "discarded"];
      } else {
        let index = Math.floor((Math.random() * 2));
        discards[index] = "discarded";
      }
    }
    return discards;
  }

  renderOpponentCards() {
    if(this.waitingForOpponent()) { return };
    let discarded = this.opponentDiscarded();
    let cards = this.opponentCards().map((card, index) => {
      return <CardComponent
                card={card}
                index={index+1}
                best_card=""
                type="opponent"
                key={index}
                winner={this.isAWinningCard(card)}
                discarded={discarded[index]} />
    });
    return cards;
  }

  opponentCards() {
    if(this.canShowOpponentCards()) {
     return this.props.game.result.other_player_cards;
    } else {
      return ["back","back"];
    }
  }

  canShowOpponentCards() {
    return (this.props.game.result && this.props.game.result.other_player_cards.length == 2)
  }

  isFinished() {
    return this.props.game.status == "finished";
  }

  resultClassName() {
    return this.isFinished() ? "result" : "";
  }

  foldButton() {
    if(this.displayFoldButton()) {
      return (<a id="fold-button" onClick={this.foldButtonClicked.bind(this)}>Fold</a>);
    }
  }

  displayFoldButton() {
   return (!this.isFinished() && !this.waitingForOpponent() && this.props.game.fold)
  }

  resultStatus(){
    if(this.props.game.result){
      return this.props.game.result.status;
    }
  }

  winDescription(){
    if(this.props.game.result){
      return this.props.game.result.win_description;
    }
  }

  loseDescription(){
    if(this.props.game.result){
      return this.props.game.result.lose_description;
    }
  }

  renderOpponentProfileImage(){
    if(this.canShowOpponentProfileImage()){
      return <OpponentProfileImageComponent opponent_profile={this.props.opponent_profile} />
    }
  }

  canShowOpponentProfileImage(){
    return (!this.waitingForOpponent() && this.props.opponent_profile && this.props.opponent_profile.image) ? true : false;
  }

  render() {
    return (
      <Provider store={this.props.store}>
        <div id="game-root" className={this.props.page.tabs["game"]}>
          <div id="game-inner">
            <div id="game" className={this.resultClassName()} >
              <div id="shine"></div>
              { this.renderOpponentProfileImage() }
              <div id="opponent-cards">{this.renderOpponentCards()}</div>
              { this.foldButton() }
              <div id="table-cards">{this.renderTableCards()}</div>
              <GameStatusComponent waiting={this.waitingForOpponent()} finished={this.isFinished()} game_status={this.props.game.status} player_status={this.props.game.player_status} />
              <PlayButtonComponent store={this.props.store} />
              <div id="player-cards">{this.renderPlayerCards()}</div>
              <BestHandComponent is_finished={this.isFinished()} winning_hand={this.winDescription()} losing_hand={this.loseDescription()} hand={this.props.game.hand_description} result_status={this.resultStatus()} />
              <Scoreboard current_score={this.props.player.current_score} />
            </div>
          </div>
        </div>
      </Provider>
     )
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page,
    game: state.game,
    player: state.player,
    opponent_profile: state.opponent_profile
  }
}

const ConnectedGameComponent = connect(mapStateToProps)(GameComponent)

export default ConnectedGameComponent;
