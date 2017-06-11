import React from "react"
import ReactDOM from "react-dom"

class NewTournamentComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      friends: props.friends,
      game: "tournament",
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

  render() {
    return (
      <div id="form-holder">
        <div className="radio">
          <label htmlFor="normal-game">
            <input type="radio" name="game_type" id="normal-game" value="tournament" onClick={this.changeGameType.bind(this)}/>
            Tournament
          </label>
        </div>
        <div className="radio">
          <label htmlFor="duel-game">
            <input type="radio" name="game_type" id="duel-game" value="duel" onClick={this.changeGameType.bind(this)} />
            Duel
          </label>
        </div>
        { this.renderFriends() }
        <div className="form-group">
          <submit className="btn btn-primary">Create</submit>
        </div>
      </div>
    )
  }

}

export default NewTournamentComponent;
