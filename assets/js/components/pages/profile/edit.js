import React from 'react';
import ReactDOM from 'react-dom';
import ProfileSettings from './partials/profile_settings.js';
import ChangePassword from './partials/change_password.js';
import FriendsList from './partials/friends_list.js';

class ProfileEditComponent extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      profileImage: this.props.image,
      stats: this.decodeStats(props),
      imageSelector: false,
      blurb: this.props.blurb,
      showChangePassword: false,
      showSettings: false,
      showFriends: false,
      showBlurb: true,
    };
  }

  decodeStats(props){
    return JSON.parse(props.stats);
  }

  updateBlurb(event){
    App.services.profile.update_blurb(event.target.value).then(data => {
      this.setState(...this.state, { blurb: data.blurb });
    });
  }

  editProfileImageClicked(){
    this.setState(...this.state, {imageSelector: !this.state.imageSelector});
  }

  editBlurbClicked(){
    this.setState(...this.state, {blurbEditor: !this.state.blurbEditor});
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

  passwordButtonClicked(){
    let showBlurb = this.state.showChangePassword;
    this.setState(...this.state, { showChangePassword: !this.state.showChangePassword, showSettings: false, showFriends: false, showBlurb: showBlurb });
  }

  friendsButtonClicked(){
    let showBlurb = this.state.showFriends;
    this.setState(...this.state, { showFriends: !this.state.showFriends, showChangePassword: false, showSettings: false, showBlurb: showBlurb });
  }

  settingsButtonClicked(){
    let showBlurb = this.state.showSettings;
    this.setState(...this.state, { showSettings: !this.state.showSettings, showChangePassword: false, showFriends: false, showBlurb: showBlurb });
  }

  renderChangePassword() {
    if(this.state.showChangePassword) {
      return(
        <ChangePassword />
      )
    }
  }

  renderFriends() {
    if(this.state.showFriends) {
      return(
        <FriendsList />
      )
    }
  }

  renderSettings() {
    if(this.state.showSettings) {
      return(
        <ProfileSettings />
      )
    }
  }

  renderBlurb(){
    let { stats } = this.state;
    if(this.state.showBlurb){
      return(
        <div id="profile-bio">
          <textarea placeholder="Bio" className="profile-bio-inner" defaultValue={this.state.blurb} onBlur={ this.updateBlurb.bind(this) }></textarea>
          <div id="user-stats">
            <table id="user-stats-table">
              <thead>
                <tr className="light">
                  <th colSpan="4">Stats</th>
                </tr>
              </thead>
              <tbody>
                <tr className="dark">
                  <td>Games Played</td>
                  <td>{ stats.games_played }</td>
                  <td>Games Won</td>
                  <td>{ stats.games_won }</td>
                </tr>
                <tr className="light">
                  <td>Games Lost</td>
                  <td>{ stats.games_lost }</td>
                  <td>Games Folded</td>
                  <td>{ stats.games_folded }</td>
                </tr>
                <tr className="dark">
                  <td>Tournaments Won</td>
                  <td>{ stats.tournaments_won }</td>
                  <td>Duels Won</td>
                  <td>{ stats.duels_won }</td>
                </tr>
                <tr className="light">
                  <td>Top Score K2</td>
                  <td>{ stats.top_score }</td>
                  <td>Win Ratio</td>
                  <td>{ this.winRatio(stats.games_played, stats.games_won) }</td>
                </tr>
              </tbody>
            </table>
          </div>
        </div>
      )
    }
  }

  winRatio(played, wins){
    if(wins == 0 || played == 0) {
      return "-";
    } else {
      let percent = wins / played * 100;
      percent = Math.round(percent * 100) / 100;
      return `${percent}%`;
    }
  }

  render() {
    return (
      <div id="edit-profile">
        <div id="user-details">
          <div id="user-details-flex">
            <div className="profile-text">
              <span className="icon icon-med icon-profile"></span>
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
          <button id="profile-settings" className="btn btn-large btn-settings" onClick={this.settingsButtonClicked.bind(this)}>Settings</button>
          <button id="profile-friends" className=" btn btn-large btn-friends" onClick={this.friendsButtonClicked.bind(this)}>Friends</button>
          <button id="profile-password" className="btn btn-large btn-password" onClick={this.passwordButtonClicked.bind(this)}>Change Password</button>
        </div>

        { this.renderChangePassword() }
        { this.renderFriends() }
        { this.renderSettings() }
        { this.renderBlurb() }

      </div>
    )
  }
}

export default ProfileEditComponent;
