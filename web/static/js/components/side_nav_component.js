import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'

class SideNavComponent extends React.Component {

  linkClicked(e) {
    e.preventDefault();
    let linkName = $(e.currentTarget).data("name");
    let links = this.props.page.links;
    let position = links[linkName]["position"];
    Object.keys(links).forEach((key) => {
      if(links[key]["position"] == position) { links[key]["active"] = false}
    });
    links[linkName]["active"] = true;
    App.store.dispatch({type: "PAGE_LINK_CLICKED", page: {links: links}});
  }

  renderLink(linkName, linkAttrs) {
    let active = linkAttrs.active ? "active" : "";
    return (
      <a href="#"
        data-name={linkName}
        data-position={linkAttrs.position}
        title={linkAttrs.title}
        id={"nav-"+linkName}
        key={linkAttrs.key}
        className={"side-nav-item " + active}
        onClick={this.linkClicked.bind(this)}>
          <span className="icon"></span>
      </a> )
  }

  renderLinks() {
    let links = [];
    if(this.props.page.links) {
      Object.keys(this.props.page.links).map( (key) => {
        links.push(this.renderLink(key, this.props.page.links[key]));
      });
    }
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
