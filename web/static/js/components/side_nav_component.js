import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'

class SideNavComponent extends React.Component {

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="nav-root">
          <a href="#" title="Profile" id="nav-profile" className="side-nav-item"><span className="icon"></span></a>
          <a href="#" title="Game Rules" id="nav-rules" className="side-nav-item"><span className="icon"></span></a>
          <a href="#" title="Chat" id="nav-chat" className="side-nav-item active"><span className="icon"></span></a>
          <a href="#" title="Tournament Position" id="nav-ladder" class="side-nav-item"><span className="icon"></span></a>
          <a href="#" title="Score" id="nav-chips" className="side-nav-item"><span className="icon"></span></a>
          <a href="#" title="Back to Game" id="nav-game" className="side-nav-item active"><span className="icon"></span></a>
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

const ConnectedSideNavComponent = connect(mapStateToProps)(SideNavComponent)

export default ConnectedSideNavComponent;
