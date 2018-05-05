import React from "react"
import ReactDOM from "react-dom"

class OpponentProfileImageComponent extends React.Component {

  openOpponentProfile(e) {
    e.preventDefault();
    App.pageComponentManager.linkClicked("profile");
  }

  render(){
    return(
      <a id="opponent-image" onClick={this.openOpponentProfile.bind(this)}>
        <img src= {this.props.opponent_profile.image} alt={this.props.opponent_profile.username}/>
        <div id="opponent-name">{this.props.opponent_profile.username }</div>
      </a>
    );
  }

}

export default OpponentProfileImageComponent;
