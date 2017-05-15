import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class ProfileComponent extends React.Component {

  render() {
    return (<Provider store={this.props.store}>
        <div id="profile-root" className={this.props.page.tabs["profile"]}>
          <div id="profile-inner">
            <h2>Opponents Profile</h2>
            <div id="profile-information">
              <p>Username: {this.props.opponent_profile.username}</p>
              <p>About: {this.props.opponent_profile.blurb}</p>
              <p><a href={ "/add_friend/" + this.props.opponent_profile.id }>Friend Me</a></p>
            </div>
          </div>
        </div>
      </Provider>)
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page,
    opponent_profile: state.opponent_profile
  }
}

const ConnectedProfileComponent = connect(mapStateToProps)(ProfileComponent)


export default ConnectedProfileComponent;
