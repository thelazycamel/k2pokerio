import React from "react"
import ReactDOM from "react-dom"

class EditProfileComponent extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      profileImage: this.props.image,
      imageSelector: false,
      blurb: this.props.blurb,
      showChangePassword: false,
      showSettings: false,
      showBlurb: true,
      passwordError: false,
      passwordErrorMessage: "",
      passwordUpdated: false
    };
  }

  updateBlurb(event){
    App.services.update_blurb_service.call(event.target.value).then(data => {
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
    App.services.profile_image_service.call(image).then(data => {
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
      "/images/profile-images/shannon.png"
    ]
  }

  logoutClicked() {
    App.services.logout_service.call();
  }

  passwordButtonClicked(){
    let showBlurb = this.state.showChangePassword;
    this.setState(...this.state, { showChangePassword: !this.state.showChangePassword, showSettings: false, showBlurb: showBlurb });
  }

  friendsButtonClicked(){
    console.log("TODO: friends page");
  }

  settingsButtonClicked(){
    let showBlurb = this.state.showSettings;
    this.setState(...this.state, { showSettings: !this.state.showSettings, showChangePassword: false, showBlurb: showBlurb });
  }

  submitNewPassword(event){
    event.preventDefault();
    App.services.update_password_service.call({
      "current-password": event.target["current-password"].value,
      "new-password": event.target["new-password"].value,
      "confirm-password": event.target["confirm-password"].value
    }).then(response => {
      if(response.status == "error") {
        this.setPasswordResponseError(response.message);
      } else {
        this.setState(...this.state, {passwordUpdated: true, passwordError: false});
      }
    });
  }

  setPasswordResponseError(message) {
    message = App.t(message)
    this.setState(...this.state, {passwordError: true, passwordErrorMessage: message, passwordUpdated: false});
  }

  submitSettings(event){
    console.log("submit settings clicked")
  }

  renderChangePassword() {
    if(this.state.showChangePassword) {
      return(
        <div id="change-password-wrapper">
          <form id="change-password-form" onSubmit={this.submitNewPassword.bind(this)}>
            <div className="form-group">
              <input type="password" name="current-password" className="form-control" placeholder="Current Password"/>
              <input type="password" name="new-password" className="form-control" placeholder="New Password"/>
              <input type="password" name="confirm-password" className="form-control" placeholder="Confirm New Password"/>
            </div>
            <div id="password-update-wrapper">
              <div id="button-wrapper">
                <button type="submit" className="btn btn-large btn-default">Update</button>
              </div>
              <p className="error" style={{display: this.state.passwordError ? "block" : "none"}}>{this.state.passwordErrorMessage}</p>
              <p className="success" style={{display: this.state.passwordUpdated ? "block" : "none"}}>{ App.t("password_updated") }</p>
            </div>
          </form>
        </div>
      )
    }
  }

  renderSettings() {
    if(this.state.showSettings) {
      return(
        <div id="profile-settings-wrapper">
          <h2>General Settings</h2>
          <div className="form-check">
            <label className="form-check-label">
              <input type="checkbox" name="email-opt-in" className="form-check-input" value=""/>
              <span className="checkbox-input-text">I would like to receive weekly news/marketing emails from K2Poker</span>
            </label>
          </div>
          <h2><span className="icon icon-small icon-monero"></span>Monero Settings</h2>
          <div className="form-group">
            <p>In order to play in the Monero Tournament, you will need to add your Monero public address (so we can pay you)
            and accept that you will be mining monero in the browser throughout the duration of the Monero Tournament</p>
            <input type="text" name="monero-address" className="form-control" placeholder="Monero Public Address"/>
          </div>
          <button className="btn btn-large btn-default" onClick={this.submitSettings.bind(this)}>Update Settings</button>
        </div>
      )
    }
  }

  renderBlurb(){
    if(this.state.showBlurb){
      return(
        <div id="profile-bio">
          <textarea placeholder="Bio" className="profile-bio-inner" defaultValue={this.state.blurb} onBlur={ this.updateBlurb.bind(this) }></textarea>
        </div>
      )
    }
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
            <img src={ this.state.profileImage } alt="Profile Image"/>
            <div id="edit-image" className="edit-icon" onClick={ this.editProfileImageClicked.bind(this) }></div>
           { this.profileImageSelect() }
          </div>
        </div>
        <div id="profile-buttons">
          <button id="profile-settings" className="btn btn-large btn-settings" onClick={this.settingsButtonClicked.bind(this)}>Settings</button>
          <button id="profile-friends" className=" btn btn-large btn-friends" onClick={this.friendsButtonClicked.bind(this)}>Friends</button>
          <button id="profile-password" className="btn btn-large btn-password" onClick={this.passwordButtonClicked.bind(this)}>Change Password</button>
        </div>

        { this.renderChangePassword() }
        { this.renderSettings() }
        { this.renderBlurb() }

        <button id="profile-logout" className="btn btn-large btn-danger" onClick={this.logoutClicked}>Logout</button>
      </div>
    )
  }
}

export default EditProfileComponent;
