import page from "../page"
import tournamentChannel from "../../channels/tournament_channel";
import gameChannel from "../../channels/game_channel";

class GameShowPage extends page {

  constructor(opts={}) {
    super(opts, "game-show");
  }

  setUpPage() {
    this.currentTournamentChannel = new tournamentChannel(this.socket);
    this.currentGameChannel = new gameChannel(this.socket);
    console.log("in game show page")
  }

}

export default GameShowPage;
