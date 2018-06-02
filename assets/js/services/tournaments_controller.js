export default class TournamentsController {

  constructor(){
    this.baseUrl = "/tournaments";
  }

  destroy(id) {
    fetch(`${this.baseUrl}/${id}`, {
      headers: {'x-csrf-token': App.settings.csrf_token},
      credentials: 'same-origin',
      method: "delete"
    }).then(response => {
      if(response.ok){
        response.json().then(data => {
          App.store.dispatch({type: "TOURNAMENT:DESTROYED", data: data});
        })
      } else {
        console.log("delete tournament failed");
      }
    });
  }

  for_user() {
    fetch(`${this.baseUrl}/for_user`, {
      headers: {'x-csrf-token': App.settings.csrf_token},
      credentials: 'same-origin',
      method: "post",
    }).then(response => {
      if(response.ok){
        response.json().then(data => {
          App.store.dispatch({type: "TOURNAMENT:RECEIVED_USER_TOURNAMENTS", data: data});
        })
      } else {
        console.log("failed getting user tournaments");
      }
    });
  }

  get_scores() {
    fetch(`${this.baseUrl}/get_scores`, {
      headers: {'x-csrf-token': App.settings.csrf_token},
      method: 'post',
      credentials: 'same-origin'
    }).then(response => {
      if(response.ok){
        response.json().then(data => {
          App.store.dispatch({type: "PLAYER:UPDATE_PLAYER_SCORE", data: data.current_player});
          App.store.dispatch({type: "TOURNAMENT:UPDATE_WINNER_SCORE", data: data.other_player});
        });
      } else {
        App.store.dispatch({type: "PLAYER:UPDATE_PLAYER_SCORE", current_score: 1, username: "error"});
      }
    });
  }

}
