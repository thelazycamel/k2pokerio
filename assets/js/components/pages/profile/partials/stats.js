import React from 'react';
import ReactDOM from 'react-dom';

class Stats extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      blurb: this.props.blurb
    }
  }

  winRatio(played, wins){
    if(wins == 0 || played == 0) {
      return "-";
    } else {
      let percent = wins / played * 100;
      percent = Math.round(percent * 100) / 100;
      return `${percent}%`;
    }
  }

  render(){
    let { stats } = this.props;
    return(
      <div id="profile-bio">
        <textarea placeholder="Bio" className="profile-bio-inner" defaultValue={this.state.blurb} onBlur={ this.props.updateBlurb } maxLength="250"></textarea>
        <div id="user-stats">
          <table id="user-stats-table">
            <thead>
              <tr className="light">
                <th colSpan="4">Player Stats</th>
              </tr>
            </thead>
            <tbody>
              <tr className="dark">
                <td>Played</td>
                <td className="value">{ stats.games_played }</td>
                <td>Won</td>
                <td className="value">{ stats.games_won }</td>
              </tr>
              <tr className="light">
                <td>Lost</td>
                <td className="value">{ stats.games_lost }</td>
                <td>Folded</td>
                <td className="value">{ stats.games_folded }</td>
              </tr>
              <tr className="dark">
                <td>Tournaments</td>
                <td className="value">{ stats.tournaments_won }</td>
                <td>Duels</td>
                <td className="value">{ stats.duels_won }</td>
              </tr>
              <tr className="light">
                <td>Top Score (K2)</td>
                <td className="value">{ stats.top_score }</td>
                <td>Win Ratio</td>
                <td className="value">{ this.winRatio(stats.games_played, stats.games_won) }</td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    )
  }
}

export default Stats;
