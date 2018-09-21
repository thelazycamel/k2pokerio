import React from "react"
import ReactDOM from "react-dom"
import page from "../page"
import TournamentNewComponent from "../../components/pages/tournament/new"

class TournamentNewPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.initializeNewTournamentComponent();
  }

  getData(name){
    let element = this.wrapperElement();
    return element.dataset[name];
  }

  wrapperElement(){
    return document.getElementById("section-wrapper")
  }

  initializeNewTournamentComponent() {
    ReactDOM.render(<TournamentNewComponent username={this.getData("username")} profile_image={this.getData("profileImage")} />, this.wrapperElement());
  }

}

export default TournamentNewPage;
