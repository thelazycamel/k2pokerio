import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class ProfileComponent extends React.Component {

  renderProfileImage() {
    if(this.props.opponent_profile.image) {
      return(
        <div id="profile-image">
          <img src= {this.props.opponent_profile.image} alt={this.props.opponent_profile.username}/>
        </div>
      )
    }
  }

  friendRequest() {
    App.services.friends.create(this.props.opponent_profile.id);
  }

  friendConfirm() {
    App.services.friends.confirm(this.props.opponent_profile.id).then(data => {
      App.store.dispatch({type: "OPPONENT_PROFILE:CONFIRMED", resp: data});
    });
  }

  renderFriendLink() {
    if(this.props.opponent_profile) {
      switch(this.props.opponent_profile.friend) {
        case "friend":
          return <h4 className="friend friend-status">Friend</h4>
        case "not_friends":
          return <h4 className="not-friends friend-status"><a href={ "#" + this.props.opponent_profile.id } onClick={this.friendRequest.bind(this)}>Friend Me</a></h4>
        case "pending_them":
          return <h4 className="pending friend-status">Pending</h4>
        case "pending_me":
          return <h4 className="confirm friend-status"><a href={ "#" + this.props.opponent_profile.id } onClick={this.friendConfirm.bind(this)}>Confirm</a></h4>
      }
    }
  }

  render() {
    return (<Provider store={this.props.store}>
        <div id="profile-root" className={this.props.page.tabs["profile"]}>
          <div id="profile-inner">
            <h2>{this.props.opponent_profile.username}</h2>
            <div id="profile-information">
              { this.renderProfileImage() }
              { this.renderFriendLink() }
              <p>{this.props.opponent_profile.blurb}</p>
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
