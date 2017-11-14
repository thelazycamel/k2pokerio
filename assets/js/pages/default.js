import page from "./page"

class DefaultPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    console.log("no js required");
    return true;
  }

}

export default DefaultPage;
