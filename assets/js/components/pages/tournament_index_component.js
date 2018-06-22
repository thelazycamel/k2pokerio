import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class TournamentIndexComponent extends React.Component {

  renderPublicTournaments() {
    if (this.props.tournament.public != undefined) {
      let tournaments = this.props.tournament.public.map((tournament, index) => {
        return (
          <tr key={"tournament-" + tournament.id}>
            <td className="tournament-icon">{tournament.icon}</td>
            <td className="title">
              <a href={"/tournaments/"+tournament.id}>{tournament.name}</a>
            </td>
            <td className="score">{tournament.current_score}</td>
            <td className="action">
              <a className="btn btn-success" href={"/tournaments/join/"+tournament.id}>Play</a>
            </td>
            <td className="action">&nbsp;</td>
          </tr>
        )
      });
      return ( <table id="public" className="tournament-table"><tbody>{tournaments}</tbody></table>)
    }
  }

  renderCurrentTournaments() {
    if (this.props.tournament.current != undefined) {
      let tournaments = this.props.tournament.current.map((tournament, index) => {
        return (
          <tr key={"tournament-" + tournament.id}>
            <td className="tournament-icon">{tournament.icon}</td>
            <td className="title">{tournament.name}</td>
            <td className="score">{tournament.current_score}</td>
            <td className="action">
              <a className="btn btn-success" href={"/tournaments/join/"+tournament.id}>Play</a>
            </td>
            <td className="action">
              <a className="btn btn-info" href={"/tournaments/"+tournament.id}>Info</a>
            </td>
            <td className="action">
              <a className="btn btn-danger" onClick={this.destroyTournament.bind(this, tournament.id)}>Delete</a>
            </td>
          </tr>
        )
      });
      return ( <table id="current" className="tournament-table"><tbody>{tournaments}</tbody></table>)
    }
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

  renderInvites() {
    if (this.props.tournament.invites != undefined) {
      let tournaments = this.props.tournament.invites.map((invite, index) => {
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
      });
      return ( <table id="invites" className="tournament-table"><tbody>{tournaments}</tbody></table>)
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
          <div className="tournament-menu">
             <div className="tournament-tab active">Public Tournaments</div>
             <div className="tournament-tab link">Private Tournaments</div>
          </div>
            {this.renderPublicTournaments() }
            {this.renderCurrentTournaments() }
            {this.renderInvites() }
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
