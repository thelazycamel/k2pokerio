import React from "react"
import ReactDOM from "react-dom"

class Badge extends React.Component {

  badgeSize(){
    return (this.props.size || "med");
  }

  achieved(){
    return this.props.achieved ? "" : "off";
  }

  render() {
    return (
      <span className={`k2-badge k2-badge-${this.props.image} k2-badge-${this.badgeSize()} ${this.achieved()}`}  title={this.props.description}></span>
    )
  }
}

export default Badge;
