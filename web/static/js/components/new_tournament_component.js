import React from "react"
import ReactDOM from "react-dom"

class NewTournamentComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      friends: props.friends,
      game: "tournament"
    }
  }

  changeGameType(e) {
    this.unselectAllFriends();
    let val = e.currentTarget.value;
    this.setState({game: val});
  }

  isDuel() {
    return this.state.game == "duel";
  }

  isTournament(){
    return this.state.game == "tournament";
  }

  selectedFriendClass(selected){
    return selected ? "success" : "default";
  }

  unselectAllFriends() {
    let friends = this.state.friends.map( (friend) => {
      return {user_id: friend.user_id, username: friend.username, selected: false}
    });
    this.setState(Object.assign({}, this.state, {friends: friends}));
  }

  toggleSelectedFriend(user_id) {
    let friends = this.state.friends.map((friend) => {
      if(friend.user_id == user_id) {
        return {user_id: friend.user_id, username: friend.username, selected: true};
      } else if(this.state.game == "duel") {
        return {user_id: friend.user_id, username: friend.username, selected: false}
      } else {
        return friend;
      }
    });
    this.setState(Object.assign({}, this.state, {friends: friends}));
  }

  renderFriends() {
    return(
      this.state.friends.map( (friend) => {
        return(
          <div key={friend.user_id} onClick={this.toggleSelectedFriend.bind(this, friend.user_id)} className={"btn btn-large btn-" + this.selectedFriendClass(friend.selected)}>{friend.username}</div>
        )
      })
    )
  }

  gameTypeChecked(type){
    return type == this.state.game;
  }

  renderGameTypeRadioButton(type) {
   return (
    <div className="radio">
      <label htmlFor={"game_type_" + type}>
        <input type="radio" name="tournament[game_type]" id={"game_type_"+type} value={type} onChange={this.changeGameType.bind(this)} defaultChecked={this.gameTypeChecked(type)} />
        {type}
      </label>
    </div>
   )
  }

  prepareForSubmit(){
    let element = document.getElementById("friend-ids");
    let selectedFriendIds = this.state.friends.map(function(friend){ if(friend.selected) { return friend.user_id }}).filter(Number);
    if(selectedFriendIds.length == 0) { return false; }
    element.value = selectedFriendIds.join(",");
    document.getElementById("new-tournament").submit();
  }

  render() {
    return (
      <div id="form-holder">
        <input type="hidden" name="tournament[friend_ids]" id="friend-ids" value=""/>
        <input type="hidden" name="_csrf_token" value={App.settings.csrf_token}/>
        { this.renderGameTypeRadioButton("tournament") }
        { this.renderGameTypeRadioButton("duel") }
        { this.renderFriends() }
        <div className="form-group">
          <button className="btn btn-primary" onClick={this.prepareForSubmit.bind(this)}>Create</button>
        </div>
      </div>
    )
  }

}

export default NewTournamentComponent;
