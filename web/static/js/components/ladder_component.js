import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Scoreboard from './presentational/scoreboard'

class LadderComponent extends React.Component {

  randomScore() {
    let number = Math.floor((Math.random() * 20))
    return Math.pow(2, number);
   }

  chipLeader() {
    return { username: "ChipLeader", score: this.randomScore() }
  }

  playerChip() {
   return (<div className="tournament-score-name"><span className="username">{this.props.player.username}</span> <span className="tournament-chip tournament-player-chip"></span></div>)
  }

  chipLeaderChip() {
   return (<div className="tournament-score-name"><span className="username">{this.chipLeader().username}</span> <span className="tournament-chip tournament-leader-chip"></span></div>)
  }

  renderPlayerCell(value) {
    let player = (value == this.props.player.current_score) ? this.playerChip() : "";
    let chipleader = (value == this.chipLeader().score) && (this.props.player.current_score != this.chipLeader().score) ? this.chipLeaderChip() : "";
    return(<td>{player} {chipleader}</td>);
  }

  renderScoreCell(value){
    return(<td>{value}</td>);
  }

  renderRows() {
    let rowNo = 20;
    let rows = [];
    for(rowNo; rowNo > -1; rowNo--) {
      let value = Math.pow(2, rowNo);
      rows.push(
        <tr key={"row-"+rowNo}>
          {this.renderPlayerCell(value)}
          {this.renderScoreCell(value)}
        </tr>
      );
    }
    return rows
  }

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="ladder-root">
          <table id="score-ladder">
            <tbody>
              {this.renderRows()}
            </tbody>
          </table>
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

const ConnectedLadderComponent = connect(mapStateToProps)(LadderComponent)

export default ConnectedLadderComponent;
