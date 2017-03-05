import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'

class TournamentGraphComponent extends React.Component {

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

  scoreboard() {
    //let score = "0000000" + this.props.player.current_score;
    let score = "0000000" + this.randomScore();
    let scoreArray = [];
    for (var i = 0; i < score.length; i++) {
      scoreArray.push(score[i]);
    }
    let scores = scoreArray.slice(Math.max(score.length -7,1));
    scores.splice(1, 0, "spacer")
    scores.splice(5, 0, "spacer");
    let elements = scores.map( (number) => {
      return <span className={"number number-" + number}></span>
    })
    return elements;
  }

  //TODO move to its own component
  ladder() {
    return (
      <table id="score-ladder">
        <tbody>
          <tr><td></td><td>1,048,576</td></tr>
          <tr><td></td><td>524,288</td></tr>
          <tr><td></td><td>262,144</td></tr>
          <tr><td></td><td>131,072</td></tr>
          <tr><td></td><td>65,536</td></tr>
          <tr><td></td><td>32,768</td></tr>
          <tr><td></td><td>16,384</td></tr>
          <tr><td></td><td>8,192</td></tr>
          <tr><td></td><td>4,096</td></tr>
          <tr><td></td><td>2,048</td></tr>
          <tr><td></td><td>1,024</td></tr>
          <tr><td></td><td>512</td></tr>
          <tr><td></td><td>256</td></tr>
          <tr><td></td><td>128</td></tr>
          <tr><td></td><td>64</td></tr>
          <tr><td></td><td>32</td></tr>
          <tr><td></td><td>16</td></tr>
          <tr><td></td><td>8</td></tr>
          <tr><td></td><td>4</td></tr>
          <tr><td></td><td>2</td></tr>
          <tr><td></td><td>1</td></tr>
        </tbody>
      </table>
    )
  }

  render() {
    return (<Provider store ={this.props.store}>
              <div id="tournament-graph-component">
                <div id="scoreboard">{this.scoreboard()}</div>
                {this.ladder()}
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

const ConnectedTournamentGraphComponent = connect(mapStateToProps)(TournamentGraphComponent)


export default ConnectedTournamentGraphComponent;
