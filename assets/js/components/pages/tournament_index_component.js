import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class TournamentIndexComponent extends React.Component {

  constructor(props){
    super(props)
    this.state = {
      area: "invitations",
      tournaments: [],
      invitations: [],
      pagination: {page_no: 1, per_page: 8, max_page: 100}
    }
  }

  componentDidMount() {
    App.services.invitations.count().then(data => {
      if(data.count > 0){
        this.loadPage(1, "invitations");
      } else {
        this.loadPage(1, "tournaments");
      }
    })
  }

  loadPage(page, area){
    let pagination = Object.assign(this.state.pagination, {page_no: page, page: page})
    if(area == "tournaments"){
      App.services.tournaments.all(pagination).then(data => {
        let pageNo = parseInt(data.pagination.params.page_no, 10);
        pagination = Object.assign(data.pagination, {page_no: pageNo, page: pageNo});
        this.setState(...this.state,
          {tournaments: data.tournaments, area: "tournaments", pagination: pagination}
        )
      });
    } else {
      App.services.invitations.index(pagination).then(data => {
        let pageNo = parseInt(data.pagination.params.page_no, 10);
        pagination = Object.assign(data.pagination, {page_no: pageNo, page: pageNo});
        this.setState(...this.state, {invitations: data.invitations, area: "invitations", pagination: pagination});
      });
    }
  }

  destroyInvite(invite_id) {
    App.services.invitations.destroy(invite_id).then(data => {
      this.setState(...this.state,
        { invitations: this.state.invitations.filter(el => { return el.id != invite_id }) }
      )
    });
  }

  destroyTournament(tournament_id) {
    App.services.tournaments.destroy(tournament_id).then(data => {
      this.setState(...this.state,
        { tournaments: this.state.tournaments.filter(el => { return el.id != tournament_id }) }
      )
    })
  }

  tournamentInfoInviteClicked() {
    //TODO
  }

  renderDeleteButton(tournament) {
    if(tournament.private) {
      return <span className="icon icon-sm icon-delete" onClick={this.destroyTournament.bind(this, tournament.id)}></span>
    }
  }

  renderPlayButton(tournament) {
    return <a className="btn btn-sm btn-join-button" href={"/tournaments/join/"+tournament.id}>Play</a>
  }

  renderTournament(tournament) {
    return (
      <tr key={"tournament-" + tournament.id}>
        <td className="tournament-icon"><img src={tournament.image} className="tourament-icon"/></td>
        <td className="title">
          <a href={"/tournaments/"+tournament.id}>{tournament.name}</a>
        </td>
        <td className="score">{tournament.current_score || tournament.starting_chips}</td>
        <td className="action">
          { this.renderPlayButton(tournament) }
        </td>
        <td className="action">
          { this.renderDeleteButton(tournament) }
        </td>
      </tr>
    )
  }

  renderTournaments() {
    return (
      <table id="current" className="tournament-table">
        <tbody>
          { this.state.tournaments.map((tournament) => { return this.renderTournament(tournament)}) }
        </tbody>
        <tfoot>
          <tr>
            <td colSpan="5">
              <div className="pagination">
                { this.renderPagination() }
              </div>
            </td>
          </tr>
        </tfoot>
      </table>
    )
  }

  renderInvite(invite, index) {
    return (
      <tr key={"invite-" + invite.id} className="invitation">
        <td className="tournament-icon">
          <img src={invite.image} className="bob"/>
        </td>
        <td className="title">
          <a href="#" onClick={this.tournamentInfoInviteClicked.bind(this, invite.id)}>
            {invite.name} from {invite.username }
          </a>
        </td>
        <td className="score">
        </td>
        <td className="action">
          <a className="btn btn-sm btn-play-button btn-accept" href={"/invitations/accept/"+invite.id}>
            Accept
          </a>
        </td>
        <td className="action">
          <span className="icon icon-sm icon-delete" onClick={this.destroyInvite.bind(this, invite.id)}></span>
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
        <tfoot>
          <tr>
            <td colSpan="5">
              <div className="pagination">
                { this.renderPagination() }
              </div>
            </td>
          </tr>
        </tfoot>
      </table>
    )
  }

  tabClicked(tab){
    this.loadPage(1, tab);
  }

  renderTabs() {
    let {area} = this.state;
    return (
      <div className="tournament-menu">
        { ["tournaments", "invitations"].map((tab) => {
          return(
            <div key={tab} className={ `tournament-tab ${(area == tab ? "active" : "link")} ${tab}`} onClick={ this.tabClicked.bind(this, tab) }>
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


  renderPagination() {
    let { pagination } = this.state;
    let textArray = [];
    if(pagination.page_no != 1 && pagination.total_pages > 1) {
      textArray.push(<button key="1" className="btn btn-sm btn-pagination" onClick={this.loadPage.bind(this, pagination.page_no -1, this.state.area) }>{ App.t("back") }</button>);
    } else {
      textArray.push(<div key="1" className="btn btn-sm btn-invisible">{ App.t("back") }</div>);
    }
    textArray.push(<span key="2">Page {pagination.page} of {pagination.total_pages}</span>)
    if(pagination.total_pages > 1 && pagination.page_no != pagination.total_pages) {
      textArray.push(<button key="3" className="btn btn-sm btn-pagination" onClick={this.loadPage.bind(this, pagination.page_no +1, this.state.area) }>{ App.t("next") }</button>);
    } else {
      textArray.push(<div key="3" className="btn btn-sm btn-invisible">{ App.t("next") }</div>);
    }
    return textArray;
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
            <a className="btn btn-k2poker" href="/tournaments/new">{App.t("create_a_game")}</a>
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
