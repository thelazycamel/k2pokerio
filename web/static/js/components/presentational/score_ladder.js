import React from "react"
import ReactDOM from "react-dom"

class ScoreLadder extends React.Component {

  playerChip() {
   return (<div className="tournament-score-name"><span className="username">{this.props.player.username}</span> <span className="tournament-chip tournament-player-chip"></span></div>)
  }

  chipLeaderChip() {
   return (<div className="tournament-score-name"><span className="username">{this.props.chipleader.username}</span> <span className="tournament-chip tournament-leader-chip"></span></div>)
  }

  renderPlayerCell(value) {
    let player = (value == this.props.player.current_score) ? this.playerChip() : "";
    let chipleader = (value == this.props.chipleader.score) && (this.props.player.current_score != this.props.chipleader.score) ? this.chipLeaderChip() : "";
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
      <table id="score-ladder">
        <tbody>
         {this.renderRows()}
        </tbody>
      </table>
    )
  }

}

export default ScoreLadder;
