export default class GameController {

  constructor(){
    this.baseUrl = "/games";
  }

  join() {
    fetch(`${this.baseUrl}/join`,
      {
        headers: {'x-csrf-token': App.settings.csrf_token},
        method: 'POST',
        credentials: 'same-origin'
      }
    ).then(response => {
      if(response.ok) {
        response.json().then(data => {
          App.store.dispatch({type: "GAME:JOINED", game_id: data.game_id});
        })
      } else {
        App.store.dispatch({type: "GAME:JOIN_FAILED", resp: {friend: "na"}});
      }
    })
  }

  opponent_profile() {
    fetch(`${this.baseUrl}/opponent_profile`,
      {
        headers: {'x-csrf-token': App.settings.csrf_token},
        method: 'POST',
        credentials: 'same-origin'
      }
    ).then(response => {
      if(response.ok) {
        response.json().then(data => {
          App.store.dispatch({type: "OPPONENT_PROFILE:NEW", profile: data});
        })
      } else {
        console.log("unable to retrieve opponent profile data");
      }
    })
  }

}

