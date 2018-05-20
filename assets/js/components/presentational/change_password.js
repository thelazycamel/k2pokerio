import React from 'react';
import ReactDOM from 'react-dom';

class ChangePassword extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      passwordError: false,
      passwordErrorMessage: "",
      passwordUpdated: false
    }
  }

  setPasswordResponseError(message) {
    message = App.t(message)
    this.setState(...this.state, {passwordError: true, passwordErrorMessage: message, passwordUpdated: false});
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

  render() {
    return (
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

export default ChangePassword;
