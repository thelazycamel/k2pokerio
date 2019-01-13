import React from 'react';
import ReactDOM from 'react-dom';
import ProfileSettings from './partials/profile_settings';
import ChangePassword from './partials/change_password';
import FriendsList from './partials/friends_list';
import Stats from './partials/stats';

class ProfileEditComponent extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      profileImage: this.props.image,
      stats: this.decodeStats(props),
      blurb: this.props.blurb,
      imageSelector: false,
      showChangePassword: false,
      pending_me: 0,
      area: "stats"
    };
  }

  componentDidMount(){
    this.getPendingMe();
  }

  getPendingMe(){
    App.services.friends.count("pending_me").then(data => {
      this.setState(...this.state, {pending_me: data.pending_me});
      /*hack*/
      let headerEl = document.getElementById("profile-friend-requests")
      if(headerEl) {
        if(data.pending_me == 0) {
          headerEl.parentNode.removeChild(headerEl);
        } else {
          headerEl.innerHTML = data.pending_me;
        }
      }
    });
  }

  updateBlurb(event){
    App.services.profile.update_blurb(event.target.value).then(data => {
      this.setState(...this.state, { blurb: data.blurb });
      if(data.badges.length > 0) {
        App.page.showBadgeAlert(data.badges);
        App.page.rebuildBadgesComponent();
      }
    });
  }

  decodeStats(props){
    return JSON.parse(props.stats);
  }

  editProfileImageClicked(){
    this.setState(...this.state, {imageSelector: !this.state.imageSelector});
  }

  selectImage(image){
    App.services.profile.update_image(image).then(data => {
      this.setState(...this.state, { imageSelector: false, profileImage: image });
    });
  }

  profileImageOption(image, index){
    return(
      <div className="profile-image-option" value={image} style={ {backgroundImage: `url('${image}')`} } key={index} onClick={ this.selectImage.bind(this, image) }></div>
    )
  }

  profileImageSelect(){
    let display = this.state.imageSelector ? "flex" : "none";
    return(
      <div id="profile-image-select" name="profile-image" style={{display: display}}>
        { this.images().map((image, index) => { return this.profileImageOption(image, index) } )}
      </div>
    )
  }

  images(){
    return [
      "/images/profile-images/bond.png",
      "/images/profile-images/clint.png",
      "/images/profile-images/damon.png",
      "/images/profile-images/delboy.png",
      "/images/profile-images/female.png",
      "/images/profile-images/lockstock.png",
      "/images/profile-images/mcqueen.png",
      "/images/profile-images/norton.png",
      "/images/profile-images/penelope.png",
      "/images/profile-images/rango.png",
      "/images/profile-images/bettyboop.png",
      "/images/profile-images/yosemitesam.png",
      "/images/profile-images/rousso.png",
      "/images/profile-images/shannon.png",
      this.props.gravatar
    ]
  }

  logoutClicked() {
    App.services.logout_service.call();
  }

  areaButtonClicked(buttonName){
    this.setState(...this.state, { area: buttonName});
  }

  renderArea() {
    switch(this.state.area) {
    case "settings":
      return <ProfileSettings />
      break;
    case "friends":
      return <FriendsList pending_me={this.state.pending_me} getPendingMe={this.getPendingMe.bind(this) } />
      break;
    case "password":
      return <ChangePassword />
      break;
    default:
      return <Stats stats={this.state.stats} blurb={this.state.blurb} updateBlurb={this.updateBlurb.bind(this)} />
    }
  }

  renderFriendRequests() {
    if(this.state.pending_me > 0) {
      return <span className="unread-counter">{this.state.pending_me}</span>
    }
  }

  selectedClass(buttonName) {
    if(buttonName == this.state.area) {
      return " btn-selected";
    } else {
      return "";
    }
  }

  render() {
    return (
      <div id="edit-profile">
        <div id="user-details">
          <div id="user-details-flex">
            <div className="profile-text">
              <span className="icon icon-med icon-cowboy"></span>
              <span className="text-username">
                {this.props.username}
                <a id="profile-logout" href="#" onClick={this.logoutClicked}>(Logout)</a>
              </span>
            </div>
            <div className="profile-text">
              <span className="icon icon-med icon-email"></span>
              <span className="text-email">{this.props.email}</span>
            </div>
          </div>
          <div id="profile-image">
            <img src={ this.state.profileImage } alt="Profile Image"/>
            <div id="edit-image" className="icon icon-med icon-edit" onClick={ this.editProfileImageClicked.bind(this) }></div>
           { this.profileImageSelect() }
          </div>
        </div>
        <div id="profile-buttons">
          <button id="profile-stats" className={"btn btn-large btn-stats" + this.selectedClass("stats") } onClick={this.areaButtonClicked.bind(this, "stats")}>Stats</button>
          <button id="profile-settings" className={"btn btn-large btn-settings" + this.selectedClass("settings") } onClick={this.areaButtonClicked.bind(this, "settings")}>Settings</button>
          <button id="profile-friends" className={"btn btn-large btn-friends" + this.selectedClass("friends") } onClick={this.areaButtonClicked.bind(this, "friends")}>
            Friends
            { this.renderFriendRequests() }
          </button>
          <button id="profile-password" className={"btn btn-large btn-password"+ this.selectedClass("password") } onClick={this.areaButtonClicked.bind(this, "password")}>Change Password</button>
        </div>

        { this.renderArea() }

      </div>
    )
  }
}

export default ProfileEditComponent;
