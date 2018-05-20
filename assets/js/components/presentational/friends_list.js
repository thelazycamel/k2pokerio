import React from 'react';
import ReactDOM from 'react-dom';

class FriendsList extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      page: 1,
      friends: []
    }
  }

  componentDidMount(){
    App.services.get_friends.call().then(response => {
      this.setState(...this.state, {friends: response.friends});
    });
  }

  deleteFriend(friend) {
    console.log(friend.id)
  }

  showFriend(friend) {
    console.log(friend.username);
  }

  friendStatus(friend) {
    if(friend.status == "pending_me") {
      return <button className="btn btn-friends">Accept</button>
    } else {
      return App.t(friend.status);
    }
  }

  renderFriend(friend) {
    return(
      <tr key={friend.id}>
        <td className="show-friend" onClick={this.showFriend.bind(this, friend)}>
          <img src={ friend.image } alt={ friend.username } className="friend-image" />
        </td>
        <td className="show-friend" onClick={this.showFriend.bind(this, friend)}>
          { friend.username }
        </td>
        <td className= { "friend-status " + friend.status}>
          { this.friendStatus(friend) }
        </td>
        <td className="actions">
          <span className="deleteFriend" onClick={this.deleteFriend.bind(this, friend)}>x</span>
        </td>
      </tr>
    )
  }

  renderFriends(){
    return (
      this.state.friends.map(friend => {
        return this.renderFriend(friend);
      })
    )
  }

  render(){
    return (
      <div id="friends-list">
        <table className="k2-table">
          <thead>
            <tr>
              <th>Search</th>
              <th><input type="text" className="form-control"/></th>
              <th className="actions"><button className="btn btn-small btn-success">Search</button></th>
            </tr>

          </thead>
          <tbody>
            { this.renderFriends() }
          </tbody>
        </table>
      </div>
    )
  }


}

export default FriendsList;
