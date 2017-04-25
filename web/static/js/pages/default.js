import page from "./page"

class DefaultPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    console.log("THE JS FOR THIS PAGE HAS NOT BEEN SETUP YET");
  }

}

export default DefaultPage;
