import React from "react"
import ReactDOM from "react-dom"

class TournamentNewComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      friends: [],
      pagination: {},
      game: "tournament",
      tournament_name: this.props.username + "'s Tournament ",
      duel_name: this.props.username + " vs "
    }
  }

  componentDidMount(){
    App.services.friends.friendsOnly(this.state.pagination).then(data => {
      let friends = data.friends.map(friend => {
        friend["selected"] = false;
        return friend;
      });
      this.setState(...this.state, {friends: friends, pagination: data.pagination})
    });
  }

  isDuel() {
    return this.state.game == "duel";
  }

  isTournament(){
    return this.state.game == "tournament";
  }

  selectedFriendClass(selected){
    return selected ? "selected-friend" : "unselected-friend";
  }

  selectAll() {
    let friends = this.state.friends.map( (friend) => {
      friend["selected"] = true;
      return friend;
    });
    this.setState(Object.assign({}, this.state, {friends: friends}));
  }

  deSelectAll() {
    let friends = this.state.friends.map( (friend) => {
      friend["selected"] = false;
      return friend;
    });
    this.setState(Object.assign({}, this.state, {friends: friends}));
  }

  updateDuelName(friend, selected){
    if(this.state.game == "duel") {
      if(selected){
        this.setState(...this.state, {duel_name: this.props.username + " vs " + friend.username})
      } else {
        this.setState(...this.state, {duel_name: this.props.username + " vs "})
      }
    }
  }

  toggleSelectedFriend(user_id) {
    let friends = this.state.friends.map((friend) => {
      if(friend.id == user_id) {
        this.updateDuelName(friend, !friend.selected);
        friend["selected"] = !friend["selected"];
        return friend;
      } else if(this.state.game == "duel") {
        friend["selected"] = false;
        return friend;
      } else {
        return friend;
      }
    });
    this.setState(...this.state, {friends: friends});
  }

  renderFriend(friend) {
    return(
      <div key={friend.id} onClick={this.toggleSelectedFriend.bind(this, friend.id)} className={"btn btn-large btn-" + this.selectedFriendClass(friend.selected)}>
        <img className="friend-image" src={friend.image} alt={friend.username}/>
        <span className="username">{friend.username}</span>
      </div>
    )
  }

  renderFriends() {
    return(
      <div className="friend-holder">
        { this.state.friends.map( (friend) => { return this.renderFriend(friend) }) }
      </div>
    )
  }

  gameTypeChecked(type){
    return type == this.state.game;
  }

  tabClicked(tab) {
    this.deSelectAll();
    this.setState(...this.state, {game: tab, duel_name: this.props.username + " vs "});
  }

  renderTabs() {
    let { game } = this.state;
    return (
      <div className="game-menu">
        { ["tournament", "duel"].map((tab) => {
          return(
            <div key={tab} className={ "tournament-tab " + (game == tab ? "active" : "link")} onClick={ this.tabClicked.bind(this, tab) }>
              <span className={"icon icon-sm icon-" + (tab == "tournament" ? "private" : "duel") + " " + (game == tab ? "active" : "")}></span>
              { App.t("private_" + tab) }
            </div>
          )
        }) }
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

  renderTournamentForm(){
    return (
      <div id="form-holder-tournament">
        <input key="tournament-input" type="text" id="input-tournament-name" name="tournament[name]" className="form-control tournament-name input-tournament" placeholder="Tournament Name" defaultValue={this.state.tournament_name}/>
        <div className="action-buttons form-group">
          <div className="buttons-left">
            <button className="btn btn-success" onClick={this.selectAll.bind(this)}>Select All</button>
            <button className="btn btn-danger" onClick={this.deSelectAll.bind(this)}>Deselect All</button>
          </div>
          <div className="buttons-right">
            <button className="btn btn-primary" onClick={this.prepareForSubmit.bind(this)}>Create</button>
          </div>
        </div>
      </div>
    )
  }

  renderDuelForm(){
    return (
      <div id="form-holder-duel">
        <input key="duel-input" type="text" id="input-duel-name" name="tournament[duel_name]" className="form-control tournament-name input-duel" value={this.state.duel_name} disabled={true} />
        <div className="action-buttons form-group">
          <div className="buttons-left">
            <p>{ App.t("choose_an_opponent") }</p>
          </div>
          <div className="buttons-right">
            <button className="btn btn-primary" onClick={this.prepareForSubmit.bind(this)}>Create</button>
          </div>
        </div>
      </div>
    )
  }

  renderForm() {
    if(this.state.game == "duel"){
      return this.renderDuelForm();
    } else {
      return this.renderTournamentForm();
    }
  }

  render() {
    return (
      <div id="tournament-wrapper">
        <section id="tournament-new-wrapper" className="tournament-area">
          <div id="tournament-header">
            <div id="user-details">
              <img src={this.props.profile_image} className="main-profile-image"/>
              <h4>{this.props.username}</h4>
            </div>
            <a className="btn btn-empty" href="/tournaments/">{App.t("back")}</a>
          </div>
          { this.renderTabs() }
          { this.renderForm() }
          { this.renderFriends() }
        </section>
        <section id="tournament-image-holder">
          <img className="game-type-image" src={"/images/pages/tournament-new-" + this.state.game + ".svg"} alt={this.state.game}/>
        </section>
      </div>
    )
  }

}

export default TournamentNewComponent;
