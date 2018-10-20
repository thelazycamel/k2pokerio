import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'

class SideNavComponent extends React.Component {

  linkClicked(e) {
    e.preventDefault();
    let linkName = $(e.currentTarget).data("name");
    App.pageComponentManager.linkClicked(linkName);
  }

  renderLink(linkName) {
    if(linkName) {
      let linkAttrs = this.props.page.links[linkName];
      let active = linkAttrs.active ? "active" : "";
      let iconSize = this.props.page.screen_size == "phone" ? "lg" : "sm";
      return (
        <a href="#"
          data-name={linkName}
          data-position={linkAttrs.position}
          title={linkAttrs.title}
          id={"nav-"+linkName}
          key={linkName}
          className={"side-nav-item " + active}
          onClick={this.linkClicked.bind(this)}>
            <span className={`icon icon-${iconSize} icon-${linkName} ${active}`}></span>
            <span className="link-title">{linkAttrs.title}</span>
        </a> )
    }
  }


  renderLinks() {
    let links = [];
    Object.keys(this.props.page.links).map( (key) => { links.push(this.renderLink(key))});
    return links;
  }

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="nav-root">
            {this.renderLinks()}
        </div>
      </Provider>
    )
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page
  }
}

const ConnectedSideNavComponent = connect(mapStateToProps)(SideNavComponent)

export default ConnectedSideNavComponent;
