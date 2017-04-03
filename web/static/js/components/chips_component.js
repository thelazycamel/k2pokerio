import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Scoreboard from './presentational/scoreboard'

class ChipsComponent extends React.Component {

  chipsClass() {
    return "chips-" +this.props.player.current_score;
  }

  render() {
    return(
      <Provider store={this.props.store}>
        <div id="chips-root">
          <div id="chips-inner">
            <Scoreboard current_score={this.props.player.current_score} key="tournament" />
            <div className="players-online">Players Online: 2000</div>
            <div className="rebuys">Rebuys: 128, 1024</div>
            <div className={this.chipsClass()} id="player-chips"></div>
          </div>
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

const ConnectedChipsComponent = connect(mapStateToProps)(ChipsComponent)

export default ConnectedChipsComponent;
