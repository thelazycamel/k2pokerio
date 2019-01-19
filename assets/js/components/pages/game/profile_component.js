import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'
import Badge from 'js/components/shared_partials/badge'

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
    App.services.friends.create({id: this.props.opponent_profile.id}).then(data => {
      App.store.dispatch({type: "OPPONENT_PROFILE:REQUESTED", resp: data});
    })
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

  renderBadges() {
    let { opponent_profile } = this.props;
    return opponent_profile.badges.map(badge => { return <Badge key={badge.id} {...badge} size="sm" /> } )
  }

  renderStats() {
    let { opponent_profile } = this.props;
    if(opponent_profile && opponent_profile.stats){
      return(
        <table id="opponent-stats">
          <thead>
            <tr>
              <th colSpan="2">Stats</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>Played</td>
              <td className="value">{ opponent_profile.games_played }</td>
            </tr>
            <tr>
              <td>Won</td>
              <td className="value">{ opponent_profile.games_won }</td>
            </tr>
            <tr>
              <td>Lost</td>
              <td className="value">{ opponent_profile.games_lost }</td>
            </tr>
            <tr>
              <td>Folded</td>
              <td className="value">{ opponent_profile.games_folded }</td>
            </tr>
            <tr>
              <td>Top Score</td>
              <td className="value">{ opponent_profile.top_score }</td>
            </tr>
            <tr>
              <td>Win Ratio</td>
              <td className="value">{ App.utils.percentage(opponent_profile.games_played, opponent_profile.games_won) }</td>
            </tr>
            <tr>
              <td>Tournaments</td>
              <td className="value">{ opponent_profile.tournaments_won }</td>
            </tr>
            <tr>
              <td>Duels</td>
              <td className="value">{ opponent_profile.duels_won }</td>
            </tr>
            <tr colSpan="2">
              <td colSpan="2" className="badge-holder">
                { this.renderBadges() }
              </td>
            </tr>
          </tbody>
        </table>
      )
    }
  }

  render() {
    return (<Provider store={this.props.store}>
        <div id="profile-root" className={this.props.page.tabs["profile"]}>
          <div id="profile-inner">
            <h2>{this.props.opponent_profile.username}</h2>
            <div id="profile-information">
              <div className="left-col">
                <p>{this.props.opponent_profile.blurb}</p>
                { this.renderStats() }
              </div>
              <div className="right-col">
                { this.renderProfileImage() }
                { this.renderFriendLink() }
              </div>
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
