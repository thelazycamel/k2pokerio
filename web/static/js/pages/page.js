class Page {

  constructor(opts, pageData) {
    if(pageData == $("body").attr("data-page")) {
      this.setUpPage();
    } else {
      return;
    }
  }

}

export default Page;
