import React from 'react';
import ReactDOM from 'react-dom';

class FriendsList extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      page: 1,
      friends: [],
      pending_me: this.props.pending_me,
      area: "",
      pagination: {page_number: 1, total_pages: 1},
      search: ""
    }
  }

  componentDidMount(){
    this.setState({area: "friends"});
    this.loadPage(1, "friends");
  }

  addFriend(friend) {
    App.services.friends.create({id: friend.id}).then(data => {
      if(data.badges.length > 0) {
        App.page.showBadgeAlert(data.badges);
        App.page.rebuildBadgesComponent();
      }
      let friends = this.state.friends.map(f => {
        if(f.id == friend.id) {f.status = data.friend}
        return f;
      });
      this.setState({friends: friends});
    })
  }

  deleteFriend(friend) {
    App.services.friends.destroy(friend.id).then(data => {
      let friends = this.state.friends.map(f => {
        if(f.id == friend.id) { f.status = data.friend }
        return f
      });
      this.props.getPendingMe();
      this.setState({friends: friends});
    })
  }

  confirmFriend(friend) {
    App.services.friends.confirm(friend.id).then(data => {
      let friends = this.state.friends.map(f => {
        if(f.id == friend.id) { f.status = data.friend }
        return f
      });
      this.props.getPendingMe()
      this.setState({friends: friends});
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
          <img src={ friend.image } alt={ friend.username } className="friend-image profile-image" />
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
    this.setState({area: area, search: ""});
    this.loadPage(1, area);
  }

  loadPage(pageNo, area){
    if(area == "search") {
      this.loadSearch(pageNo);
    } else {
      App.services.friends.index({page: pageNo, per_page: 7, area: area, max_page: 100}).then(response => {
        let pending_me = area == "pending_me" ? response.entries.length : this.state.pending_me;
        this.setState(
          {
            friends: response.entries,
            pagination: {
              page_number: response.page_number,
              total_pages: response.total_pages
            },
            pending_me: pending_me
          }
        );
      });
    }
  }

  renderPagination() {
    let { pagination } = this.state;
    let textArray = [];
    if(pagination.page_number != 1 && pagination.total_pages > 1) {
      textArray.push(<button key="1" className="btn btn-sm btn-pagination" onClick={this.loadPage.bind(this, pagination.page_number -1, this.state.area) }>{ App.t("back") }</button>);
    } else {
      textArray.push(<div key="1" className="btn btn-sm btn-invisible">{ App.t("back") }</div>);
    }
    textArray.push(<span key="2">Page {pagination.page_number} of {pagination.total_pages}</span>)
    if(pagination.total_pages > 1 && pagination.page_number != pagination.total_pages) {
      textArray.push(<button key="3" className="btn btn-sm btn-pagination" onClick={this.loadPage.bind(this, pagination.page_number +1, this.state.area) }>{ App.t("next") }</button>);
    } else {
      textArray.push(<div key="3" className="btn btn-sm btn-invisible">{ App.t("next") }</div>);
    }
    return textArray;
  }

  renderPendingMeCount() {
    if(this.props.pending_me > 0) {
      return <span className="unread-counter">{this.props.pending_me}</span>
    }
  }

  renderPendingMeButton(){
    return (
      <div className={`friends-tab pending-me-tab ${this.state.area === "pending_me" ? "active" : "link"}`} onClick={this.changeArea.bind(this, "pending_me")}>
        { App.t("pending_me") }
        { this.renderPendingMeCount() }
      </div>
    )
  }

  renderFriendsButton(){
    if(this.state.area === "friends") {
      return <div className="friends-tab all-friends-tab active">{App.t("friends")}</div>
    } else {
      return <div className="friends-tab all-friends-tab link" onClick={this.changeArea.bind(this, "friends")}>{App.t("friends")}</div>
    }
  }

  renderPendingThemButton() {
    // I have removed this as think it unnecessary to have 
    if(this.state.area === "pending_them"){
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
    this.setState({search: e.target.value});
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
      this.setState({
          friends: response.entries,
          area: "search",
          pagination: {
            total_pages: response.total_pages,
            page_number: response.page_number
          }
        }
      );
    });
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
                  { this.renderFriendsButton() }
                  { this.renderPendingMeButton() }
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
