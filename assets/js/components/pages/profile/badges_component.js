import React from 'react';
import ReactDOM from 'react-dom';
import Badge from 'components/shared_partials/badge';

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
      this.setState(state => (
        { ...this.state,
          badges: data.badges
        }
      ));
    });
  }

  renderBadgeRow(badge){
    if(badge.gold){
      let image = badge.achieved ? badge.image : "unknown";
      return(
        <td key={badge.group + "" + badge.position} title={ badge.name }>
          <Badge image={image} name={badge.name} description={badge.description} size="med" key={badge.id}/>
        </td>
      )
    } else {
      return(
        <td key={badge.group + "" + badge.position} title={ badge.name }>
          <Badge {...badge} size="med" key={badge.id} />
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
