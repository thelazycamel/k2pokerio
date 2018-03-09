import page from "./page"

class DefaultPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    return true;
  }

}

export default DefaultPage;
