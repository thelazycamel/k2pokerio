import React from "react"
import ReactDOM from "react-dom"
import page from "../page"
import ProfileEditComponent from "../../components/pages/profile/profile_edit_component"
import BadgesComponent from "../../components/pages/profile/badges_component"

class ProfileEditPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.initializeMyProfileComponent();
    this.initializeBadgesComponent();
  }

  initializeMyProfileComponent() {
    let element = document.getElementById('edit-profile-wrapper')
    ReactDOM.render(<ProfileEditComponent
                      username=  {element.dataset.username}
                      blurb=     {element.dataset.blurb}
                      image=     {element.dataset.image}
                      email=     {element.dataset.email}
                      gravatar = {element.dataset.gravatar}
                      stats =    {element.dataset.stats}
                     />, element);
  }

  initializeBadgesComponent() {
    let element = document.getElementById('profile-badges')
    ReactDOM.render(<BadgesComponent/>, element);
  }

}

export default ProfileEditPage;
