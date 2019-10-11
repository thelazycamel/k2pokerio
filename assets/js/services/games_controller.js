import BaseController from 'services/base_controller'

export default class GameController extends BaseController {

  constructor(){
    super();
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

  quit() {
    return (
      fetch(`${this.baseUrl}/quit`,
        {
          headers: {'x-csrf-token': App.settings.csrf_token},
          method: 'POST',
          credentials: 'same-origin'
        }
      )
    )
  }

  duelFix() {
    return (
      fetch(`${this.baseUrl}/duel_fix`,
        {
          headers: {'x-csrf-token': App.settings.csrf_token},
          method: 'POST',
          credentials: 'same-origin'
        }
      ).then(response => {
        if(response.ok) { return response.json() }
      })
    )
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

