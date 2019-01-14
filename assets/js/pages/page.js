import React from "react"
import socket from "../socket"
import { renderToStaticMarkup } from 'react-dom/server'
import BadgeAlertText from 'js/components/shared_partials/badge_alert_text';

class Page {

  constructor(opts) {
    this.setUpPage();
    this.setUpAlerts();
  }

  connectSocket() {
    if(window.userToken != "") {
      App.socket = socket;
      App.socket.connect();
    }
  }

  setUpAlerts() {
   let params = this.searchParamsToObject();
   if(params["alert"] !== undefined){
     this.showAlert(params["alert"], params["alertMessage"]);
   } else {
    this.setUpEventGlobalListeners();
   }
  }

  /* TODO: Really this should all be done by a nice react component, but having spent some time trying
   * with refs etc, it didnt work, so falling back to plain ole' JS for now.
   * further note: checkout react portals */

  showAlert(type, message) {
    let placeHolder = document.getElementById("alert-popup-holder")
    placeHolder.innerHTML = '<div class="alert alert-' +  type + '" style="display: block"><a class="close" data-dismiss="alert">×</a><span>'+message+'</span></div>';
    this.setUpEventGlobalListeners();
  }

  showBadgeAlert(badges){
    this.showAlert("success", renderToStaticMarkup(<BadgeAlertText badges={badges}/>));
  }

  searchParamsToObject() {
    var search = location.search.substring(1);
    if(search !== "" && search !== undefined){
      return JSON.parse('{"' + search.replace(/&/g, '","').replace(/=/g,'":"') + '"}', function(key, value) { return key===""?value:decodeURIComponent(value) })
    } else {
      return {}
    }
  }

  // PRIVATE

  setUpEventGlobalListeners() {
    let closeAlert = document.getElementsByClassName("close")[0];
    if(closeAlert){
      closeAlert.onclick = function() {
        let alert = document.getElementsByClassName("alert")[0];
        if(alert){
          alert.parentNode.removeChild(alert);
        }
      }
    }
    window.setTimeout(function(){
      let alert = document.getElementsByClassName("alert")[0];
      if(alert) {
        alert.parentNode.removeChild(alert);
      }
    }, 5000);
  }

}

export default Page;
