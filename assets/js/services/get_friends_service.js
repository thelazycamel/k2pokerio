export default class GetFriendsService {

  constructor(){
    this.url = "/friends";
  }

  call() {
    return (
      fetch(this.url,
        { headers: {'x-csrf-token': App.settings.csrf_token},
          credentials: 'same-origin'}
      ).then(response => { return response.json() })
    )
  }

}
