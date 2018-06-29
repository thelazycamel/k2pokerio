import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class TournamentIndexComponent extends React.Component {

  constructor(props){
    super(props)
    this.state = {
      invitation_count: 0,
      area: "invitations",
      tournaments: [],
      invitations: [],
      pagination: {page: 1, per_page: 7, max_page: 100}
    }
  }

  componentDidMount() {
    App.services.invitations.count().then(data => {
      if(data.count > 0){
        this.setState(...this.state, {invitation_count: data.count});
        this.getInvitations();
      } else {
        this.getTournaments();
      }
    })
  }

  getInvitations() {
    App.services.invitations.all(this.state.pagination).then(data => {
      this.setState(...this.state, {invitations: data.invitations, area: "invitations"});
    });
  }

  getTournaments() {
    App.services.tournaments.all(this.state.pagination).then(data => {
      this.setState(...this.state, {tournaments: data.tournaments, area: "tournaments"});
    });
  }

  renderTournaments() {
    let tournaments = this.state.tournaments.map((tournament, index) => {
      return (
        <tr key={"tournament-" + tournament.id}>
          <td className="tournament-icon">{tournament.icon}</td>
          <td className="title">
            <a href={"/tournaments/"+tournament.id}>{tournament.name}</a>
          </td>
          <td className="score">{tournament.current_score || tournament.starting_chips}</td>
          <td className="action">
            <a className="btn btn-success" href={"/tournaments/join/"+tournament.id}>Play</a>
          </td>
          <td className="action">
            <a className="btn btn-danger" onClick={this.destroyTournament.bind(this, tournament.id)}>Delete</a>
          </td>
        </tr>
      )
    });
    return ( <table id="current" className="tournament-table"><tbody>{tournaments}</tbody></table>)
  }

  destroyInvite(invite_id) {
    App.store.dispatch({type: "TOURNAMENT:DESTROY_INVITE", invite_id: invite_id});
    return false;
  }

  destroyTournament(tournament_id) {
    App.store.dispatch({type: "TOURNAMENT:DESTROY_TOURNAMENT", tournament_id: tournament_id});
    return false;
  }

  tournamentInfoInviteClicked() {
    App.store.dispatch({type: "TOURNAMENT:INFO_WITH_INVITE", invite_id: invite_id})
  }

  renderInvite(invite, index) {
    return (
      <tr key={"invite-" + invite.id} className="invitation">
        <td className="tournament-icon">
          <span className="icon icon-med icon-invite active"></span>
        </td>
        <td className="title">
          <a href="#" onClick={this.tournamentInfoInviteClicked.bind(this, invite.id)}>
            {invite.name} from {invite.username }
          </a>
        </td>
        <td className="score">&nbsp;</td>
        <td className="action">
          <a className="btn btn-success" href={"/invitations/accept/"+invite.id}>Accept</a>
        </td>
        <td className="action">
          <a className="btn btn-danger" onClick={this.destroyInvite.bind(this, invite.id)}>Delete</a>
        </td>
      </tr>
    )
  }

  renderInvites() {
    return (
      <table id="invites" className="tournament-table">
        <tbody>
          { this.state.invitations.map((invite, index) => { return this.renderInvite(invite, index)}) }
        </tbody>
      </table>
    )
  }

  tabClicked(tab){
    if(tab == "tournaments") {
      this.getTournaments();
    } else {
      this.getInvitations();
    }
  }

  renderTabs() {
    let {area, invitation_count} = this.state;
    console.log(area)
    return (
      <div className="tournament-menu">
        { ["tournaments", "invitations"].map((tab) => {
          return(
            <div key={tab} className={ "tournament-tab " + (area == tab ? "active" : "link")} onClick={ this.tabClicked.bind(this, tab) }>
              { App.t(tab) }
            </div>
          )
        }) }
      </div>
    )
  }

  renderTable() {
   if(this.state.area == "tournaments") {
     return this.renderTournaments()
   } else {
     return this.renderInvites()
   }
  }

  render() {
    return (
      <Provider store={this.props.store}>
        <div id="tournament-index-root">
          <div id="tournament-header">
            <div id="user-details">
              <img src={this.props.profile_image} className="main-profile-image"/>
              <h4>{this.props.username}</h4>
            </div>
            <a className="btn btn-warning" href="/tournaments/new">Create a Private Tournament</a>
          </div>
            {this.renderTabs()}
            {this.renderTable()}
        </div>
      </Provider>
    )
  }

}

const mapStateToProps = (state) => {
  return {
    tournament: state.tournament
  }
}

const ConnectedTournamentIndexComponent = connect(mapStateToProps)(TournamentIndexComponent)

export default ConnectedTournamentIndexComponent;
