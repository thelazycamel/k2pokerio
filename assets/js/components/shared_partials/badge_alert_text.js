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

  renderBadges(){
    return(
      this.props.badges.map(badge => { return this.renderBadge(badge) })
    )
  }

  render() {
    return (
      <div className="alert-badge-wrapper">
        { this.renderBadges() }
        <h5>New {this.pluralizeBadge()} Awarded</h5>
      </div>
    )
  }
}

export default BadgeAlertText;
