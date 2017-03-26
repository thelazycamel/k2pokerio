import React from "react"
import ReactDOM from "react-dom"
import { connect } from 'react-redux'
import { Provider } from 'react-redux'

class BotRequestComponent extends React.Component {

  close() {
    App.store.dispatch({type: "PAGE:HIDE_BOT_POPUP"});
    App.store.dispatch({type: "PAGE:SET_BOT_POPUP"});
  }

  playBot() {
    App.store.dispatch({type: "GAME:BOT_REQUEST"});
    App.store.dispatch({type: "PAGE:HIDE_BOT_POPUP"});
  }

  showOrHide() {
    return this.props.page.botRequest ? this.props.page.botRequest : "hide";
  }

  render() {
    return (
      <Provider store ={this.props.store}>
        <div id="bot-request-root" className={this.showOrHide()}>
          <div className="modal-header">
            <h3 className="bot-request-title">Play a bot?</h3>
            <button type="button" className="close" onClick={this.close}>
              <span aria-hidden="true">&times;</span>
            </button>
          </div>
          <div className="bot-request-body">
            <p>There are currently no players available at your level</p>
            <p>Would you like to play a bot instead.</p>
          </div>
          <div className="bot-request-footer">
             <button type="button" className="btn btn-primary" onClick={this.playBot}>Play Bot</button>
             <button type="button" className="btn btn-secondary" onClick={this.close}>Close</button>
          </div>
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

const ConnectedBotRequestComponent = connect(mapStateToProps)(BotRequestComponent)

export default ConnectedBotRequestComponent;
