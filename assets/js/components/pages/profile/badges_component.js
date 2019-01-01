import React from 'react';
import ReactDOM from 'react-dom';

class BadgesComponent extends React.Component {

  constructor(props){
    super(props);
    this.state = {
      badges: []
    };
  }

  componentDidMount(){
    this.getBadges();
  }

  getBadges(){
    App.services.badges.index({}).then(data => {
      this.setState(...this.state, {badges: data.badges});
    });
  }

  renderBadgeRow(badge){
    if(badge.gold){
      let image = badge.achieved ? badge.image : "unknown";
      return(
        <td key={badge.group + "" + badge.position} title={ badge.name }>
          <span className={ `k2-badge k2-badge-${image} k2-badge-med`} title={badge.description}></span>
        </td>
      )
    } else {
      let achieved = badge.achieved ? "" : "off";
      return(
        <td key={badge.group + "" + badge.position} title={ badge.name }>
          <span className={ `k2-badge k2-badge-${badge.image} k2-badge-med ${achieved}`} title={badge.description}></span>
        </td>
      )
    }
  }

  renderGroup(group){
    let badges = this.state.badges.filter(badge => badge.group == group);
    return(
      <tr className= {"group-" + group}>
        { badges.sort(badge => badge.position).map(badge => { return this.renderBadgeRow(badge) }) }
      </tr>
    )

  }

  render() {
    return (
      <table className="badges-table">
        <thead>
          <tr>
            <td colSpan="5">
              <h2>Badges</h2>
            </td>
          </tr>
        </thead>
        <tbody>
          { this.renderGroup(1) }
          { this.renderGroup(2) }
          { this.renderGroup(3) }
          { this.renderGroup(4) }
          { this.renderGroup(5) }
          { this.renderGroup(6) }
        </tbody>
      </table>
    )
  }
}

export default BadgesComponent;
