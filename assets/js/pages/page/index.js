import page from "../page"

class PageIndexPage extends page {

  constructor(opts={}) {
    super(opts);
  }

  setUpPage() {
    this.parallaxSetup();
  }

  parallaxSetup(){
    window.addEventListener("scroll", this.parallaxScroll);
  }

  parallaxScroll() {
    // TODO move the middle down at half speed of scroll
    let element = document.getElementById("middle");
    let position = element.getBoundingClientRect().top;
    let current = parseInt(window.getComputedStyle(element).getPropertyValue("top"),10);
    let scroll = 100 - position + current + "px";
    //element.style.top = scroll;
  }

}
export default PageIndexPage;
