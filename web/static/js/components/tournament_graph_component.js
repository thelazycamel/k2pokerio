import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'

class TournamentGraphComponent extends React.Component {

  render() {
    return (<div id="tournament-graph">
              <h3>{this.props.title} </h3>
              <p>React is plugged in! and <br/>
              if I am blue and top right corner,<br/>
              sass is also plugged in</p>
            </div>)
  }
}

const mapStateToProps = (state) => {
  return {
    tournament: state.tournament,
  }
}

const ConnectedTournamentGraphComponent = connect(mapStateToProps)(TournamentGraphComponent)


export default ConnectedTournamentGraphComponent;
