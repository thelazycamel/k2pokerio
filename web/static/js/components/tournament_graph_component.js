import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'

class TournamentGraphComponent extends React.Component {

  render() {
    return (<Provider store ={this.props.store}>
              <div id="tournament-graph-component">
                <div id="background-chips"></div>
                <div id="winner-chips"></div>
                <div id="player-chips"></div>
              </div>
           </Provider>
           )
  }
}

const mapStateToProps = (state) => {
  return {
    tournament: state.tournament,
  }
}

const ConnectedTournamentGraphComponent = connect(mapStateToProps)(TournamentGraphComponent)


export default ConnectedTournamentGraphComponent;
