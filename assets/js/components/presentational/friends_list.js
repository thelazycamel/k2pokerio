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
    App.services.friends.index().then(response => {
      this.setState(...this.state, {friends: response.friends});
    });
  }

  addFriend(friend) {
    App.services.friends.create(friend.id).then(data => {
      let friends = this.state.friends.map(f => {
        if(f.id == friend.id) {f.status = data.friend}
        return f;
      });
      this.setState(...this.state, {friends: friends});
    })
  }

  deleteFriend(friend) {
    App.services.friends.destroy(friend.id).then(data => {
      let friends = this.state.friends.map(f => {
        if(f.id == friend.id) { f.status = data.friend }
        return f
      });
      this.setState(...this.state, {friends: friends});
    })
  }

  confirmFriend(friend) {
    App.services.friends.confirm(friend.id).then(data => {
      let friends = this.state.friends.map(f => {
        if(f.id == friend.id) { f.status = data.friend }
        return f
      });
      this.setState(...this.state, {friends: friends});
    });
  }

  friendStatus(friend) {
    if(friend.status == "pending_me") {
      return <button className="btn btn-success" onClick={this.confirmFriend.bind(this, friend)}>Confirm</button>
    } else {
      return App.t(friend.status);
    }
  }

  renderActions(friend) {
    if(friend.status == "not_friends") {
      return(
        <span className="add-friend" onClick={this.addFriend.bind(this, friend)}>Add</span>
      )
    } else {
      return(
        <span className="delete-friend" onClick={this.deleteFriend.bind(this, friend)}>x</span>
      )
    }
  }

  renderFriend(friend) {
    return(
      <tr key={friend.id}>
        <td className="show-friend profile-image">
          <img src={ friend.image } alt={ friend.username } className="friend-image" />
        </td>
        <td className="show-friend user-name">
          { friend.username }
        </td>
        <td className= { "friend-status " + friend.status}>
          { this.friendStatus(friend) }
        </td>
        <td className="actions">
          {this.renderActions(friend) }
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
              <th colSpan="3" ><input type="search" className="form-control" placeholder="Search"/></th>
              <th className="actions"><button className="btn btn-small btn-default">Search</button></th>
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
