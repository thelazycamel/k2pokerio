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
            <td>{tournament.name}</td>
            <td className="score">{tournament.current_score}</td>
            <td className="action">
              <a className="btn btn-success" href={"/tournaments/join/"+tournament.id}>Play</a>
            </td>
            <td className="action">
              <a className="btn btn-info" href={"/tournaments/info/"+tournament.id}>Info</a>
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
            <th>{tournament.name}</th>
            <td className="score">{tournament.current_score}</td>
            <td className="action">
              <a className="btn btn-success" href={"/tournaments/join/"+tournament.id}>Play</a>
            </td>
            <td className="action">
              <a className="btn btn-info" href={"/tournaments/info/"+tournament.id}>Info</a>
            </td>
            <td className="action">
              <a className="btn btn-danger" href={"/tournaments/leave/"+tournament.id}>Leave</a>
            </td>
          </tr>
        )
      });
      return ( <table id="current" className="tournament-table"><tbody>{tournaments}</tbody></table>)
    }
  }

  renderInvites() {
    if (this.props.tournament.invites != undefined) {
      let tournaments = this.props.tournament.invites.map((invite, index) => {
        return (
          <tr key={"invite-" + invite.id} className="invitation">
            <th>{invite.name} from {invite.username }</th>
            <td className="score">&nbsp;</td>
            <td className="action">
              <a className="btn btn-success" href={"/invitations/accept/"+invite.id}>Accept</a>
            </td>
            <td className="action">
              <a className="btn btn-info" href={"/tournaments/info/"+invite.tournament_id}>Info</a>
            </td>
            <td className="action">
              <a className="btn btn-danger" href={"/invitations/destroy/"+invite.id}>Delete</a>
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
          <h1>Available Tournaments</h1>
          <h2>Public</h2>
            {this.renderPublicTournaments() }
          <h2>Private</h2>
            {this.renderCurrentTournaments() }
          <h2>Invitations</h2>
            {this.renderInvites() }
          <a className="btn btn-succes" href="/tournaments/new">Create a Private Tournament</a>
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
