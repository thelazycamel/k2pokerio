import page from "../page"

class TournamentIndexPage extends page {

  constructor(opts={}) {
    super(opts, "tournament-index");
  }

  setUpPage() {
    console.log("you are on the tournament index");
  }

}

export default TournamentIndexPage;
