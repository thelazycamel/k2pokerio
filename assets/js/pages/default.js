import page from "./page"

class DefaultPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  testing() {
    return "TODO: Testing Pages is going to be hard with lots of mocks for sockets, services and the DOM";
  }

  setUpPage() {
    console.log("no js required");
    return true;
  }

}

export default DefaultPage;
