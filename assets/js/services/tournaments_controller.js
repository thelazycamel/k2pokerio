import BaseController from 'services/base_controller'

export default class TournamentsController extends BaseController {

  constructor(){
    super();
    this.baseUrl = "/tournaments";
  }

  all(params) {
    return (
      fetch(this.baseUrl + "/for_user?" + this.parameterize(params), {
        headers: {'x-csrf-token': App.settings.csrf_token},
        credentials: 'same-origin',
        method: "get",
      }).then(response => { return response.json() })
    )
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
