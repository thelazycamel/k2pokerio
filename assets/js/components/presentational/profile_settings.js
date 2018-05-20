import React from 'react';
import ReactDOM from 'react-dom';

class ProfileSettings extends React.Component {

  submitSettings(event){
    console.log("submit settings clicked")
  }

  render() {
    return (
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

export default ProfileSettings;
