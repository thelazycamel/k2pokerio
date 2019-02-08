import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Scoreboard from './../../shared_partials/scoreboard'

class LadderComponent extends React.Component {

  scoreClass(value){
    if(this.props.player){
      return (this.props.player.current_score == value) ? "current-score score" : "score";
    }
  }

  renderPlayer(value){
    if(this.props.player){
      if(this.props.player.current_score == value){
        return(
            <div className={"player-score size-" + this.size(value)}>
              <span className="username">{this.props.player.username}</span>
              <span className="tournament-chip" title={this.props.player.username}></span>
            </div>
        )
      }
    }
  }

  renderValue(value) {
    if(value <= this.props.maxScore) {
      return <span className={this.scoreClass(value)}>{value}</span>
    } else {
      return <span className={this.scoreClass(value) + " empty"}></span>
    }
  }

  renderScoreCell(value){
    return(
      <td className="score-cell">
          { this.renderPlayer(value) }
          { this.renderValue(value) }
          { this.renderOtherPlayer(value) }
      </td>);
  }

  renderOtherPlayer(value){
    if(this.props.tournament.winner){
      if(this.props.tournament.winner.current_score == value){
        return(
          <div className={"other-player-score size-" + this.size(value)}>
            <div className="tournament-chip" title={this.props.tournament.winner.username}></div>
            <div className="username">{this.props.tournament.winner.username}</div>
          </div>
        )
      }
    }
  }

  size(value){
    if(value < 100) {
      return "xlarge";
    } else if((value >= 100) && (value <= 1000)) {
      return "large";
    } else if((value >= 1000) && (value <= 10000)) {
      return "medium";
    } else if((value >= 10000) && (value <= 100000)) {
      return "small";
    } else {
      return "xsmall";
    }
  }

  rowClass(value){
    if(value > this.props.maxScore) {
      return "empty";
    } else {
      return "normal";
    }
  }

  renderRows() {
    let rowNo = 20;
    let rows = [];
    for(rowNo; rowNo > -1; rowNo--) {
      let value = Math.pow(2, rowNo);
      rows.push(
        <tr key={"row-"+rowNo} className={this.rowClass(value)}>
          {this.renderScoreCell(value)}
        </tr>
      );
    }
    return rows
  }

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="ladder-root" className={this.props.page.tabs["ladder"]}>
          <div id="ladder-inner">
            <table id="score-ladder" className={ "score-size-"+this.props.maxScore }>
              <tbody>
                {this.renderRows()}
              </tbody>
            </table>
          </div>
        </div>
      </Provider>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page,
    tournament: state.tournament,
    player: state.player
  }
}

const ConnectedLadderComponent = connect(mapStateToProps)(LadderComponent)

export default ConnectedLadderComponent;
