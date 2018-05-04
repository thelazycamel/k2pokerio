import React from "react"
import ReactDOM from "react-dom"

class EditProfileComponent extends React.Component {

  images(){
    return [
      "bettyboop.png",
      "bond.png",
      "clint.png",
      "damon.png",
      "delboy.png",
      "female.png",
      "lockstock.png",
      "mcqueen.png",
      "norton.png",
      "penelope.png",
      "rango.png",
      "rousso.png",
      "shannon.png",
      "yosemitesam.png"
    ]
  }

  logoutClicked() {
    App.services.logout_service.call();
  }

  render() {
    return (
      <div id="edit-profile">
        <div id="user-details">
          <div id="user-details-flex">
            <div className="profile-text">
              <span className="icon icon-profile"></span>
              <span className="text-username">{this.props.username}</span>
            </div>
            <div className="profile-text">
              <span className="icon icon-email"></span>
              <span className="text-email">{this.props.email}</span>
            </div>
          </div>
          <div id="profile-image">
            <img src={"/images/profile-images/" + this.props.image} alt="Profile Image"/>
            <div id="edit-image" className="edit-icon"></div>
          </div>
        </div>
        <div id="profile-buttons">
          <button id="profile-password" className="btn btn-large btn-password">Change Password</button>
          <button id="profile-friends" className=" btn btn-large btn-friends">Friends</button>
          <button id="profile-settings" className="btn btn-large btn-settings">Settings</button>
        </div>
        <div id="profile-bio">
          <p>{this.props.blurb}</p>
          <div id="profile-bio-edit" style={{display: "none"}}>
            <label>Bio</label>
            <textarea name="blurb" defaultValue={this.props.blurb}></textarea>
          </div>
          <div id="edit-blurb" className="edit-icon"></div>
        </div>
        <button id="profile-logout" className="btn btn-large btn-danger" onClick={this.logoutClicked}>Logout</button>
      </div>
    )
  }
}

export default EditProfileComponent;
