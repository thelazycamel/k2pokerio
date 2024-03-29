import React from "react"
import ReactDOM from "react-dom"
import TournamentCreatedPopup from "../../popups/tournament_created_popup"

class TournamentNewComponent extends React.Component {

  constructor(props) {
    super(props);
    this.state = {
      friends: [],
      pagination: {per_page: 0},
      gameType: "tournament",
      tournamentName: this.props.username + "'s Tournament ",
      description: "",
      maxScore: 1048576,
      duelName: this.props.username + " vs "
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
    if(this.state.gameType == "duel") {
      if(selected){
        this.setState(...this.state, {duelName: this.props.username + " vs " + friend.username})
      } else {
        this.setState(...this.state, {duelName: this.props.username + " vs "})
      }
    }
  }

  tournamentNameChanged(e) {
    this.setState(...this.state, {tournamentName: e.currentTarget.value});
  }

  tournamentDescriptionChanged(e) {
    this.setState(...this.state, {tournamentDescription: e.currentTarget.value});
  }

  maxScoreChanged(e) {
    this.setState(...this.state, {maxScore: e.currentTarget.value});
  }

  duelNameChanged(e) {
    this.setState(...this.state, {duelName: e.currentTarget.value});
  }

  toggleSelectedFriend(user_id) {
    let friends = this.state.friends.map((friend) => {
      if(friend.id == user_id) {
        this.updateDuelName(friend, !friend.selected);
        friend["selected"] = !friend["selected"];
        return friend;
      } else if(this.state.gameType == "duel") {
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

  tabClicked(tab) {
    this.deSelectAll();
    this.setState(...this.state, {gameType: tab, duelName: this.props.username + " vs "});
  }

  submitForm(e) {
    let friendIds = this.state.friends.filter(friend => { return friend.selected }).map(friend => {return friend.id})
    let name = (this.state.gameType == "tournament") ? this.state.tournamentName : this.state.duelName;
    let description = this.state.tournamentDescription;
    let maxScore = this.state.maxScore;
    let params = {
      friend_ids: friendIds,
      game_type: this.state.gameType,
      name: name,
      max_score: maxScore,
      description: description
    }
    App.services.tournaments.create(params).then(data => {
      if(data.status == "ok") {
        document.location = '/tournaments/' + data.id + "?alert=success&alertMessage=Your%20Tournament%20has%20been%20created";
      } else {
        this.showAlert("danger", data.message)
      }
    })
  }

  showAlert(type, message) {
    App.page.showAlert(type, message)
  }

  closeAlert(){
    React.unmountComponentAtNode();
  }

  renderTabs() {
    let { gameType } = this.state;
    return (
      <div className="game-menu">
        { ["tournament", "duel"].map((tab) => {
          return(
            <div key={tab} className={ "tournament-tab " + (gameType == tab ? "active" : "link")} onClick={ this.tabClicked.bind(this, tab) }>
              <span className={"icon icon-sm icon-" + (tab == "tournament" ? "private" : "duel") + " " + (gameType == tab ? "active" : "")}></span>
              { App.t("private_" + tab) }
            </div>
          )
        }) }
      </div>
    )
  }

  renderTournamentForm(){
    return (
      <div id="form-holder-tournament">
        <input key="tournament-input"
               type="text"
               id="input-tournament-name"
               name="tournament[name]"
               className="form-control tournament-input"
               placeholder="Tournament Name"
               defaultValue={this.state.tournamentName}
               maxLength="30"
               onChange={this.tournamentNameChanged.bind(this)}
               />
        <input type="text"
               name="tournament[description]"
               className="form-control tournament-input"
               placeholder="Short Description"
               maxLength="254"
               onChange={ this.tournamentDescriptionChanged.bind(this) }
               />
        <select name="tournament[max_score]" defaultValue="MaxScore" className="form-control tournament-input" onChange={this.maxScoreChanged.bind(this)}>
          <option value="MaxScore" disabled>Winning Score</option>
          <option value="64">64</option>
          <option value="128">128</option>
          <option value="256">256</option>
          <option value="512">512</option>
          <option value="1024">1024</option>
          <option value="2048">2048</option>
          <option value="4096">4096</option>
          <option value="8192">8192</option>
          <option value="16384">16384</option>
          <option value="131072">131072</option>
          <option value="1048576">1048576</option>
        </select>
        <div className="action-buttons form-group">
          <div className="buttons-left">
            <button className="btn btn-success" onClick={this.selectAll.bind(this)}>Select All</button>
            <button className="btn btn-danger" onClick={this.deSelectAll.bind(this)}>Deselect All</button>
          </div>
          <div className="buttons-right">
            <button className="btn btn-primary" onClick={this.submitForm.bind(this)}>Create</button>
          </div>
        </div>
      </div>
    )
  }

  renderDuelForm(){
    return (
      <div id="form-holder-duel">
        <input key="duel-input"
               type="text"
               id="input-duel-name"
               name="tournament[duel_name]"
               className="form-control tournament-input"
               value={this.state.duelName}
               disabled={true}
               onChange={this.duelNameChanged.bind(this)}
               />
        <div className="action-buttons form-group">
          <div className="buttons-left">
            <p>{ App.t("choose_an_opponent") }</p>
          </div>
          <div className="buttons-right">
            <button className="btn btn-primary" onClick={this.submitForm.bind(this)}>Create</button>
          </div>
        </div>
      </div>
    )
  }

  renderForm() {
    if(this.state.gameType == "duel"){
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
          <img className="game-type-image" src={"/images/pages/tournament-new-" + this.state.gameType + ".svg"} alt={this.state.gameType}/>
        </section>
      </div>
    )
  }

}

export default TournamentNewComponent;
