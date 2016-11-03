import React from "react"
import ReactDOM from "react-dom"

class TournamentGraphComponent extends React.Component {

  render() {
    return (<div id="tournament-graph">
              <h3>{this.props.page} page </h3>
              <p>React is plugged in! and <br/>
              if I am blue and top right corner,<br/>
              sass is also plugged in</p>
            </div>)
  }
}

export default TournamentGraphComponent;
