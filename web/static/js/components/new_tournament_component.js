import React from "react"
import ReactDOM from "react-dom"

class NewTournamentComponent extends React.Component {

  /* TODO: show the options depending on the number of friends selected */

  constructor(props) {
    super(props);
    this.state = {
      friends: [],
      game: {show: "hide", value: "normal"},
      lose: {show: "hide", value: "all"},
      min:  {show: "hide", value: "1"},
      max:  {show: "hide", value: "1,048,576"},
    }
  }

  changeGameType(e) {
    let val = e.currentTarget.value;
    if(val == "normal") {
      this.setState(Object.assign({}, this.state, {game: {value: val}, lose: {show: "show"}, min: {show: "show"}, max: {show: "show"}}));
    } else {
      this.setState(Object.assign({}, this.state, {game: {value: val}, lose: {show: "hide"}, min: {show: "hide"}, max: {show: "hide"}}));
    }
  }

  isDuel() {
    return this.state.friends.length == 1;
  }

  isGroupGame(){
    return this.state.friends.length > 1;
  }

  addFriends(e) {
    this.setState(Object.assign({}, this.state, {friends: [e.currentTarget.value]}));
  }

  changeLoseType(e) {

  }

  changeMinMax(e) {

  }

  renderGameType() {
    let showOrHide = this.isDuel() ? "show" : "hide";
    return (
      <div className={"form-group " + showOrHide}>
        <label>Game Type</label>
        <select name="game_type" value={this.state.game.value} className="form-control" onChange={this.changeGameType.bind(this)}>
          <option value="normal">Mountain Climber (normal)</option>
          <option value="robber">Rob thy Neighbour</option>
        </select>
      </div>
    )
  }

  renderLoseType() {
    return (
      <div className={"form-group " + this.state.lose.show }>
        <label>Lose everything or half the stack</label>
        <select name="lose_type" value={this.state.lose.value} className="form-control" onChange={this.changeLoseType.bind(this)}>
          <option value="all">Lose Everything</option>
          <option value="half">Half the Stack</option>
        </select>
      </div>
    )
  }

  renderStartingChips() {
    return (
      <div className={"form-group " + this.state.min.show }>
        <label>Starting Chips</label>
        <select name="starting_chips" value={this.state.min.value} className="form-control" onChange={this.changeMinMax.bind(this)}>
          <option>1</option>
          <option>2</option>
          <option>4</option>
          <option>8</option>
          <option>16</option>
          <option>32</option>
          <option>64</option>
          <option>128</option>
          <option>256</option>
          <option>512</option>
          <option>1024</option>
        </select>
      </div>
    )
  }

  renderWinningStack() {
    return (
      <div className={"form-group " + this.state.max.show }>
        <label>Winning Stack</label>
        <select name="starting_chips" value={this.state.max.value} className="form-control" onChange={this.changeMinMax.bind(this)}>
          <option>1,048,576</option>
          <option>524,288</option>
          <option>262,144</option>
          <option>131,072</option>
          <option>65,536</option>
          <option>32,768</option>
          <option>16,384</option>
          <option>8,192</option>
          <option>4,096</option>
          <option>2,048</option>
          <option>1,024</option>
        </select>
      </div>
    )
  }

  renderInvitees() {
    return (
      <div className="form-group">
        <label>Invitees</label>
        <input type="text" name="friends" className="form-control" placeholder="text search to find list of friends, all at the top" onChange={this.addFriends.bind(this)}/>
      </div>
    )
  }

  render() {
    return (
      <div id="form-holder">
        { this.renderInvitees() }
        { this.renderGameType() }
        { this.renderLoseType() }
        { this.renderStartingChips() }
        { this.renderWinningStack() }
        <div className="form-group">
          <label>Date</label>
          <input type="date" name="start-time" className="form-control"/>
        </div>
        <div className="form-group">
          <submit className="btn btn-primary">Create</submit>
        </div>
      </div>
    )
  }

}

export default NewTournamentComponent;
