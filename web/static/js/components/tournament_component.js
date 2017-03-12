import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Scoreboard from './presentational/scoreboard'
import ScoreLadder from './presentational/score_ladder'

class TournamentComponent extends React.Component {

  randomScore() {
    if(this.score){
      return this.score;
    }
    let number = Math.floor((Math.random() * 20))
    this.score = Math.pow(2, number)
    return this.score;
  }

  chipsClass() {
    //return "chips-" +this.props.player.current_score;
    return "chips-" + this.randomScore();
  }

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="tournament-component">
          <ScoreLadder player={this.props.player} chipleader={ {username: "chipleader", score: this.randomScore()} } />
          <Scoreboard current_score={this.props.player.current_score} key="tournament" />
          <div id="background-chips"></div>
          <div id="winner-chips"></div>
          <div className={this.chipsClass()} id="player-chips"></div>
        </div>
      </Provider>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    tournament: state.tournament,
    player: state.player
  }
}

const ConnectedTournamentComponent = connect(mapStateToProps)(TournamentComponent)

export default ConnectedTournamentComponent;
