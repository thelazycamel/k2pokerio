import React from "react"
import ReactDOM from "react-dom"

class EditProfileComponent extends React.Component {

  constructor(props) {
    super(props);
    let imageStates = {};
    this.images().forEach( (image) => { imageStates[image] = (props.image == image)});
    this.state = {images: imageStates};
  }

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

  selectedImageClass(selected) {
    return selected ? "selected" : "";
  }

  selectImage(e) {
    let images = {};
    for(let key of Object.keys(this.state.images)) {
      images[key] = false;
    }
    let image = e.currentTarget.value;
    images[image] = true;
    this.setState(Object.assign({}, this.state, {images: images}));
  }

  renderProfileImages(){
    let images = [];
    for (let image of Object.keys(this.state.images)) {
      images.push(
        <label key={image} className={this.selectedImageClass(this.state.images[image])}>
          <input type="radio" name="profile[image]" value={image} onChange={this.selectImage.bind(this)}/>
          <img src={"/images/profile-images/" + image} />
        </label>
      )
    };
    return images;
  }

  render() {
    return (
      <div id="form-holder">
        <input type="hidden" name="_csrf_token" value={App.settings.csrf_token}/>
        <input type="hidden" name="_method" value="put"/>
        <h2>{this.props.username }</h2>
        <div className="form-group">
          <label>Bio</label>
          <textarea name="profile[blurb]" className="form-control" placeholder="Your Bio" defaultValue={this.props.blurb}></textarea>
        </div>
        <div className="form-group profile-image">
          { this.renderProfileImages() }
        </div>
        <div className="form-group">
          <button type="submit" className="btn btn-primary">Update Profile</button>
        </div>
      </div>
    )
  }
}

export default EditProfileComponent;
