import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class ProfileComponent extends React.Component {

  render() {
    return (<Provider store={this.props.store}>
        <div id="profile-root" className={this.props.page.tabs["profile"]}>
          <div id="profile-inner">
            <h2>Profile</h2>
            <div id="profile-information">
              <p>user or opponents profile</p>
            </div>
          </div>
        </div>
      </Provider>)
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page,
    player: state.player
  }
}

const ConnectedProfileComponent = connect(mapStateToProps)(ProfileComponent)


export default ConnectedProfileComponent;
