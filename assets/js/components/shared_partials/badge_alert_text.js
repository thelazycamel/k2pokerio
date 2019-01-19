import React from "react"
import ReactDOM from "react-dom"
import Badge from './badge'

class BadgeAlertText extends React.Component {

  pluralizeBadge(){
    return this.props.badges.length > 1 ? "badges" : "badge";
  }

  renderBadge(badge){
    return <Badge {...badge} achieved={true} size="sm" key={badge.id}/>
  }

  renderImages(){
    return(
      this.props.badges.map(badge => { return this.renderBadge(badge) })
    )
  }

  renderNames() {
    const names = this.props.badges.map(badge => { return badge.name })
    return names.join(", ")
  }

  render() {
    return (
      <div className="alert-badge-wrapper">
        { this.renderImages() }
        <h5>
          New {this.pluralizeBadge()} Awarded.&nbsp;
          { this.renderNames() }
        </h5>
      </div>
    )
  }
}

export default BadgeAlertText;
