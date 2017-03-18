class PageComponentManager {

  init() {
    this.screen_size = this.screenSwitcher();
    App.store.dispatch({type: "PAGE:RESIZE", page: {screen_size: this.screenSwitcher(), links: this.links()}})
    this.setUpListeners()
  }

  setUpListeners() {
    let resizeEvent;
    let _this = this;
    $(window).resize(function() {
      clearTimeout(_this.resizeEvent);
      _this.resizeEvent = setTimeout(_this.resizing.bind(_this), 200);
    });
  }

  resizing() {
    this.init();
  }

  screenSwitcher() {
    let width = $(window).width();
    return function() {
        if(width <= 500)                  { return "phone" }   else
        if(width > 500 && width < 768)    { return "plablet" } else
        if(width >= 768 && width < 1024)  { return "vtablet" } else
        if(width >= 1024 && width < 1200) { return "htablet" } else
        if(width >= 1200)                 { return "monitor" }
    }();
  }

  links() {
    return ({
      "game": {title: "Back to Game", position: this.linkPosition("middle"), active: this.activeLink("game"), key: 1},
      "ladder": {title: "Tournament Position", position: this.linkPosition("top"), active: this.activeLink("ladder"), key: 2},
      "chips": {title: "Score and Rebuys", position: this.linkPosition("top"), active: this.activeLink("chips"), key: 3},
      "chat": {title: "Tournament Room Chat", position: this.linkPosition("bottom"), active: this.activeLink("chat"), key: 4},
      "rules": {title: "Tournament / Game Rules", position: this.linkPosition("bottom"), active: this.activeLink("rules"), key: 5},
      "profile": {title: "My Profile", position: this.linkPosition("bottom"), active: this.activeLink("profile"), key: 6}
    })
  }

  linkPosition(position) {
    return this.screen_size == "plablet" ? "middle" : position;
  }

  activeLink(linkName) {
    if(this.activeTabs()[this.screen_size].indexOf(linkName) != -1) {
      return true;
    } else {
      return false;
    }
  }

  activeTabs() {
    return ({
      "phone":   [],
      "plablet": ["game"],
      "vtablet": ["ladder", "chat"],
      "htablet": ["ladder", "chat"],
      "monitor": ["chat"]
    })
  }


}

export default PageComponentManager;
