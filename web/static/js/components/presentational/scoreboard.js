import React from "react"
import ReactDOM from "react-dom"

class Scoreboard extends React.Component {

  buildScoreboard(){
    let score = "0000000" + this.props.current_score;
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

  render() {
    return (
      <div className="scoreboard">
        {this.buildScoreboard()}
      </div>
    )
  }

}

export default Scoreboard;
