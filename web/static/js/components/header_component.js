import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'
import Scoreboard from './presentational/scoreboard'

class HeaderComponent extends React.Component {

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="header-component">
          <Scoreboard current_score = {this.props.player.current_score} />
        </div>
      </Provider>
    )
  }

}

const mapStateToProps = (state) => {
  return {
    player: state.player
  }
}

const ConnectedHeaderComponent = connect(mapStateToProps)(HeaderComponent)

export default ConnectedHeaderComponent;
