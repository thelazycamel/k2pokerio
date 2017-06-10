import React from "react"
import ReactDOM from "react-dom"

class NewTournamentComponent extends React.Component {

  /* TODO: show the options depending on the number of friends selected */

  constructor(props) {
    super(props);
    this.state = {
      friends: [],
      game: "tournament",
    }
  }

  changeGameType(e) {
    let val = e.currentTarget.value;
    this.setState(Object.assign({}, this.state, {game: val, friends: []}));
  }

  isDuel() {
    return this.state.game == "duel";
  }

  isTournament(){
    return this.state.game == "tournament";
  }

  searchFriends(e) {
    let val = e.currentTarget.value;
    if(val.length > 2) {
      let friends = this.state.friends;
      App.services.search_friends.call({query: val, game: this.state.game}, function(resp){
        console.log("SEARCH FRIENDS RESP", resp);
      });
    }
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
        <div className="form-group">
          <label>Invitees</label>
          <input type="text" name="friends" className="form-control" placeholder="text search to find list of friends, all at the top" onKeyUp={this.searchFriends.bind(this)}/>
        </div>
        <div className="form-group">
          <submit className="btn btn-primary">Create</submit>
        </div>
      </div>
    )
  }

}

export default NewTournamentComponent;
