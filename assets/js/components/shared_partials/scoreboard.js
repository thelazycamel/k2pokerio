import React from "react"
import ReactDOM from "react-dom"

class Scoreboard extends React.Component {

  constructor(props) {
    super(props);
    this.state = {};
  }

  componentWillReceiveProps(nextProps){
    if(this.props.current_score != nextProps.current_score){
      this.setState(state => (
        { ...this.state,
          animate: "animate"
        }
      ));
    } else {
      this.setState(state => (
        { ...this.state,
          animate: ""
        }
      ));
    }
  }

  buildScoreboard(){
    let score = "0000000" + this.props.current_score;
    let scoreArray = [];
    for (var i = 0; i < score.length; i++) {
      scoreArray.push(score[i]);
    }
    let scores = scoreArray.slice(Math.max(score.length -7,1));
    scores.splice(1, 0, "spacer")
    scores.splice(5, 0, "spacer");
    let elements = scores.map( (number, index) => {
      return <span className={"number number-" + number + " ani-num-" + index + " " + this.state.animate} key={"score"+index}></span>
    })
    return elements;
  }

  render() {
    return (
      <div className="scoreboard">
        <div className="scoreboard-inner">
          {this.buildScoreboard()}
        </div>
      </div>
    )
  }

}

export default Scoreboard;
