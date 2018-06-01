import React from 'react';
import ReactDOM from 'react-dom';

class FriendsList extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      page: 1,
      friends: [],
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
        <td className="show-friend">
          <img src={ friend.image } alt={ friend.username } className="friend-image" />
        </td>
        <td className="show-friend">
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
              <th colSpan="2" ><input type="search" className="form-control" placeholder="Search"/></th>
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
