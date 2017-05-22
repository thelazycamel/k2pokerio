import React from "react"
import ReactDOM from "react-dom"
import page from "../page"
import EditProfileComponent from "../../components/edit_profile_component"

class ProfileEditPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.initializeMyProfileComponent();
  }

  initializeMyProfileComponent() {
    let element = document.getElementById('edit-profile')
    ReactDOM.render(<EditProfileComponent username={element.dataset.username} blurb={element.dataset.blurb} image={element.dataset.image}/>, element);
  }

}

export default ProfileEditPage;
