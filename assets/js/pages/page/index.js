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
    // TODO tidy this function to calculate each element, by its z-index
    // no need to do each individually
    let frame = document.getElementById("homepage");
    let position = frame.getBoundingClientRect().top;
    if(position < -20) {position = -20;}
    let sky = document.getElementById("sky");
    let mountain = document.getElementById("mountain");
    let rock = document.getElementById("middle");
    let foreground = document.getElementById("foreground");
    let suites = document.getElementById("suites");
    let skyTop = (50 - position) * 0.5;
    let mountainTop = (50 - position) * 1;
    let rockTop = (50 - position) * 1.5;
    let foregroundTop = (50 - position) * 1.75;
    let suitesTop = (50 + position) * 2.25;
    mountain.style.top = mountainTop + "px";
    rock.style.top = rockTop + "px";
    foreground.style.top = foregroundTop + "px";
    suites.style.top = suitesTop + "px";
  }

}
export default PageIndexPage;
