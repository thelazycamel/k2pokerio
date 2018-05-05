import React from "react"
import ReactDOM from "react-dom"

class EditProfileComponent extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      profileImage: this.props.image,
      imageSelector: false,
      blurb: this.props.blurb
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
    let display = this.state.imageSelector ? "block" : "none";
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
            <img src={this.state.profileImage} alt="Profile Image"/>
            <div id="edit-image" className="edit-icon" onClick={ this.editProfileImageClicked.bind(this) }></div>
           { this.profileImageSelect() }
          </div>
        </div>
        <div id="profile-buttons">
          <button id="profile-password" className="btn btn-large btn-password">Change Password</button>
          <button id="profile-friends" className=" btn btn-large btn-friends">Friends</button>
          <button id="profile-settings" className="btn btn-large btn-settings">Settings</button>
        </div>
        <div id="profile-bio">
          <textarea placeholder="Bio" className="profile-bio-inner" defaultValue={this.state.blurb} onBlur={ this.updateBlurb.bind(this) }></textarea>
        </div>
        <button id="profile-logout" className="btn btn-large btn-danger" onClick={this.logoutClicked}>Logout</button>
      </div>
    )
  }
}

export default EditProfileComponent;
