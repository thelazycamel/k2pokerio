class Page {

  constructor(opts, pageData) {
    if(pageData == $("body").attr("data-page")) {
      this.socket = opts["socket"];
      this.setUpPage();
    } else {
      return;
    }
  }

}

export default Page;
