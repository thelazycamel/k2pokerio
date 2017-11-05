import page from "./page"

class DefaultPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  test() {
    return "Hello World";
  }

  setUpPage() {
    console.log("no js required");
  }

}

export default DefaultPage;
