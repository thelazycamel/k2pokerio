import React from "react"
import ReactDOM from "react-dom"
import page from "../page"
import EditProfileComponent from "../../components/pages/edit_profile_component"

class ProfileEditPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.initializeMyProfileComponent();
  }

  initializeMyProfileComponent() {
    let element = document.getElementById('edit-profile-wrapper')
    ReactDOM.render(<EditProfileComponent
                      username= {element.dataset.username}
                      blurb=    {element.dataset.blurb}
                      image=    {element.dataset.image}
                      email=    {element.dataset.email} />, element);
  }

}

export default ProfileEditPage;
