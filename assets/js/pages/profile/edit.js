import React from "react"
import ReactDOM from "react-dom"
import page from "../page"
import ProfileEditComponent from "../../components/pages/profile/edit"

class ProfileEditPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.initializeMyProfileComponent();
  }

  initializeMyProfileComponent() {
    let element = document.getElementById('edit-profile-wrapper')
    ReactDOM.render(<ProfileEditComponent
                      username= {element.dataset.username}
                      blurb=    {element.dataset.blurb}
                      image=    {element.dataset.image}
                      email=    {element.dataset.email} />, element);
  }

}

export default ProfileEditPage;
