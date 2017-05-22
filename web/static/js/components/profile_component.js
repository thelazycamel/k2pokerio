import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class ProfileComponent extends React.Component {

  renderProfileImage(){
    if(this.props.opponent_profile.image) {
      return(
        <div id="profile-image">
          <img src= {"/images/profile-images/" +this.props.opponent_profile.image} alt={this.props.opponent_profile.username}/>
        </div>
      )
    }
  }

  render() {
    return (<Provider store={this.props.store}>
        <div id="profile-root" className={this.props.page.tabs["profile"]}>
          <div id="profile-inner">
            <h2>{this.props.opponent_profile.username}</h2>
            <div id="profile-information">
            { this.renderProfileImage() }
              <h4><a href={ "/add_friend/" + this.props.opponent_profile.id }>Friend Me</a></h4>
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
