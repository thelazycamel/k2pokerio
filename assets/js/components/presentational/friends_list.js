import React from 'react';
import ReactDOM from 'react-dom';

class FriendsList extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      page: 1,
      friends: [],
      area: "",
      pagination: {},
      search: ""
    }
  }

  componentDidMount(){
    App.services.friends.count("pending_me").then(data => {
      if(data.pending_me == 0) {
        this.setState(...this.state, {area: "friends"});
        this.loadPage(1, "friends");
      } else {
        this.setState(...this.state, {area: "pending_me"});
        this.loadPage(1, "pending_me");
      }
    })
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
    } else if (friend.status == "friend" && this.state.area == "search") {
      return <span className="icon icon-sm icon-friend"></span>
    } else if (friend.status == "pending_them") {
      return App.t(friend.status);
    }
  }

  renderActions(friend) {
    if(friend.status == "not_friends") {
      return(
        <span className="icon icon-sm icon-add" onClick={this.addFriend.bind(this, friend)}></span>
      )
    } else {
      return(
        <span className="icon icon-sm icon-delete" onClick={this.deleteFriend.bind(this, friend)}></span>
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

  changeArea(area){
    this.setState(...this.state, {area: area, search: ""});
    this.loadPage(1, area);
  }

  loadPage(pageNo, area){
    if(area == "search") {
      this.loadSearch(pageNo);
    } else {
      App.services.friends.index({page: pageNo, per_page: 7, area: area, max_page: 100}).then(response => {
        this.setState(...this.state, {friends: response.friends, pagination: response.pagination});
      });
    }
  }

  renderPagination() {
    let { pagination } = this.state;
    let textArray = [];
    if(pagination.page != 1 && pagination.total_pages > 1) {
      textArray.push(<button key="1" className="btn btn-sm btn-pagination" onClick={this.loadPage.bind(this, pagination.page -1, this.state.area) }>{ App.t("back") }</button>);
    } else {
      textArray.push(<div key="1" className="btn btn-sm btn-invisible">{ App.t("back") }</div>);
    }
    textArray.push(<span key="2">Page {pagination.page} of {pagination.total_pages}</span>)
    if(pagination.total_pages > 1 && pagination.page != pagination.total_pages) {
      textArray.push(<button key="3" className="btn btn-sm btn-pagination" onClick={this.loadPage.bind(this, pagination.page +1, this.state.area) }>{ App.t("next") }</button>);
    } else {
      textArray.push(<div key="3" className="btn btn-sm btn-invisible">{ App.t("next") }</div>);
    }
    return textArray;
  }

  renderPendingMeButton(){
    if(this.state.area == "pending_me"){
      return <div className="friends-tab active">{App.t("pending_me")}</div>
    } else {
      return <div className="friends-tab link" onClick={this.changeArea.bind(this, "pending_me")}>{App.t("pending_me")}</div>
    }
  }

  renderFriendsButton(){
    if(this.state.area == "friends") {
      return <div className="friends-tab active">{App.t("friends")}</div>
    } else {
      return <div className="friends-tab link" onClick={this.changeArea.bind(this, "friends")}>{App.t("friends")}</div>
    }
  }

  renderPendingThemButton() {
    // I have removed this as think it unnecessary to have 
    if(this.state.area == "pending_them"){
      return <div className="friends-tab active">{App.t("pending_them")}</div>
    } else {
      return <div className="friends-tab link" onClick={this.changeArea.bind(this, "pending_them")}>{App.t("pending_them")}</div>
    }
  }

  renderTablePadding(){
    let { friends } = this.state;
    let html = [];
    if(friends.length < 7) {
      let rows = 7 - friends.length;
      for(rows; rows > 0; rows --) {
        html.push(<tr className="padded-row" key={"padding-" +rows}><td colSpan="4">&nbsp;</td></tr>)
      }
    }
    return html;
  }

  updateSearchValue(e){
    this.setState(...this.state, {search: e.target.value})
    if(e.target.value.length >= 3) {
      this.loadSearch(1);
    }
  }

  searchClicked() {
    if(this.state.search.length >= 3) {
      this.loadSearch(1);
    } else {
      console.log("not enough chars");
    }
  }

  loadSearch(page) {
    App.services.friends.search({query: this.state.search, page: page, per_page: 7, max_page: 100}).then(response => {
      this.setState(...this.state, {friends: response.friends, pagination: response.pagination, area: "search"});
    })
  }

  render(){
    return (
      <div id="friends-list">
        <table className="k2-table">
          <thead>
            <tr>
              <th colSpan="3" >
                <input type="search" className="form-control search-users" placeholder="Search Players" value={this.state.search} onChange={this.updateSearchValue.bind(this)}/>
              </th>
              <th className="actions"><button className="btn btn-small btn-search" onClick={this.searchClicked.bind(this)}>Search</button></th>
            </tr>
            <tr>
              <th colSpan="4">
                <div className={"area-buttons " + this.state.area}>
                  { this.renderPendingMeButton() }
                  { this.renderFriendsButton() }
                </div>
              </th>
            </tr>
          </thead>
          <tbody>
            { this.renderFriends() }
            { this.renderTablePadding() }
          </tbody>
          <tfoot>
            <tr>
              <td colSpan="4">
                <div className="pagination">
                  { this.renderPagination() }
                </div>
              </td>
            </tr>
          </tfoot>
        </table>
      </div>
    )
  }

}

export default FriendsList;
