class PageComponentManager {

  init() {
    this.screen_size = this.screenSwitcher();
    this.screen_width = $(window).width();
    App.store.dispatch({type: "PAGE:RESIZE", page: {screen_size: this.screenSwitcher(), links: this.links(), tabs: this.tabs()}});
    this.setUpListeners();
  }

  tabs() {
    return this.defaultTabs()[this.screenSwitcher()];
  }

  defaultTabs() {
    return ({
      "monitor": {"game": "show", "chips": "show", "ladder": "show", "chat": "show", "rules": "hide", "profile": "hide"},
      "htablet": {"game": "show", "chips": "hide", "ladder": "show", "chat": "show", "rules": "hide", "profile": "hide"},
      "vtablet": {"game": "show", "chips": "hide", "ladder": "show", "chat": "show", "rules": "hide", "profile": "hide"},
      "plablet": {"game": "show", "chips": "hide", "ladder": "hide", "chat": "hide", "rules": "hide", "profile": "hide"},
      "phone": {"game": "show", "chips": "hide", "ladder": "hide", "chat": "hide", "rules": "hide", "profile": "hide"},
    })
  }

  linkClicked(linkName) {
    let tabs = App.store.getState().page.tabs;
    let links = App.store.getState().page.links;
    let position = links[linkName]["position"];
    Object.keys(links).forEach((key) => {
      if(links[key]["position"] == position) {
        tabs[key] = "hide";
        links[key].active = false;
      }
    });
    tabs[linkName] = "show";
    links[linkName].active = true;
    App.store.dispatch({type: "PAGE:LINK_CLICKED", page: {links: links, tabs: tabs}});
  }

  setUpListeners() {
    let resizeEvent;
    let _this = this;
    $(window).resize(function() {
      clearTimeout(_this.resizeEvent);
      if(_this.screen_width != $(window).width()) {
        _this.resizeEvent = setTimeout(_this.resizing.bind(_this), 100);
      }
    });
  }

  resizing() {
    $(".card").attr("style", "");
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
      "game": {title: "Back to Game", position: this.linkPosition("middle"), active: this.activeLink("game")},
      "ladder": {title: "Tournament Position", position: this.linkPosition("top"), active: this.activeLink("ladder")},
      "chips": {title: "Score and Rebuys", position: this.linkPosition("top"), active: this.activeLink("chips")},
      "chat": {title: "Tournament Room Chat", position: this.linkPosition("bottom"), active: this.activeLink("chat")},
      "rules": {title: "Tournament / Game Rules", position: this.linkPosition("bottom"), active: this.activeLink("rules")},
      "profile": {title: "My Profile", position: this.linkPosition("bottom"), active: this.activeLink("profile")}
    })
  }

  linkPosition(position) {
    switch(this.screen_size) {
      case "phone":
        return "bottom";
        break;
      case "plablet":
        return "middle";
        break;
      default:
        return position;
    }
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
      "phone":   ["game"],
      "plablet": ["game"],
      "vtablet": ["ladder", "chat"],
      "htablet": ["ladder", "chat"],
      "monitor": ["chat"]
    })
  }


}

export default PageComponentManager;
