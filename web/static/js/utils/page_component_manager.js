/* TODO: this whole class is a mess to handle the links and tabs opening for different
 * responsive states, move it to react */

class PageComponentManager {

  init() {
    this.screen_size = this.screenSwitcher();
    this.screen_width = $(window).width();
    App.store.dispatch({type: "PAGE:RESIZE", page: {screen_size: this.screenSwitcher(), links: this.links()}});
    this.setUpListeners();
    this.showHideTabs();
  }

  showHideTabs() {
    switch(this.screen_size){
    case "monitor":
      $("#game-root, #chips-root, #ladder-root, #chat-root").show();
      $("#rules-root, #profile-root").hide();
      break;
    case "htablet":
      $("#game-root, #ladder-root, #chat-root").show();
      $("#chips-root, #rules-root, #profile-root").hide();
      break;
    case "vtablet":
      $("#game-root, #ladder-root, #chat-root").show();
      $("#chips-root, #rules-root, #profile-root").hide();
      break;
    case "plablet":
      $("#game-root").show();
      $("#chips-root, #rules-root, #profile-root, #ladder-root, #chat-root").hide();
      break;
    case "phone":
      $("#game-root").show();
      $("#chips-root, #rules-root, #profile-root, #ladder-root, #chat-root").hide();
      break;
    }
  }


  /* this is all very smelly, come back and fix it */

  showTab(tab, links) {
    let components = []
    let position = links[tab]["position"];
    Object.keys(links).forEach((key) => {
      if(links[key]["position"] == position) { components.push("#" + key + "-root")}
    });
    components.forEach(function(el){
      $(el).hide();
    });
    $("#" + tab + "-root").show();
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
      "game": {title: "Back to Game", position: this.linkPosition("middle"), active: this.activeLink("game"), key: 1},
      "ladder": {title: "Tournament Position", position: this.linkPosition("top"), active: this.activeLink("ladder"), key: 2},
      "chips": {title: "Score and Rebuys", position: this.linkPosition("top"), active: this.activeLink("chips"), key: 3},
      "chat": {title: "Tournament Room Chat", position: this.linkPosition("bottom"), active: this.activeLink("chat"), key: 4},
      "rules": {title: "Tournament / Game Rules", position: this.linkPosition("bottom"), active: this.activeLink("rules"), key: 5},
      "profile": {title: "My Profile", position: this.linkPosition("bottom"), active: this.activeLink("profile"), key: 6}
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
