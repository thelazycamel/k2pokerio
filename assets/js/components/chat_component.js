import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'
import Comment from 'components/shared_partials/comment'

class ChatComponent extends React.Component {

  handleKeyPress(e) {
    if(e.key == "Enter") {
      this.props.store.dispatch({type: "CHAT:CREATE_COMMENT", comment: e.currentTarget.value});
      e.currentTarget.value = "";
    }
  }

  renderComments() {
    if(this.props.chat.comments) {
      return this.props.chat.comments.map( (comment) =>
        <Comment comment={comment} key={comment.chat_id} />
      )
    }
  }

  renderInput() {
    if(App.settings.chat_disabled == "true"){
      return <input type="text" id="new-chat" placeholder="Chat disabled, please contact support" disabled />
    } else if(App.settings.logged_in == "true"){
      return <input type="text" className="logged-in" id="new-chat" onKeyPress={this.handleKeyPress.bind(this)} />
    } else {
      return <input type="text" id="new-chat" placeholder="Log in to join the conversation" disabled />
    }
 }

  render() {
    return (<Provider store={this.props.store}>
        <div id="chat-root" className={this.props.page.tabs["chat"]}>
          <div id="chat-inner">
            <div id="chat-fader"></div>
            <h2>{this.props.tournament.tournament_name}</h2>
            <div id="chats">
              <div id="comments-holder">
                { this.renderComments() }
              </div>
            </div>
            { this.renderInput() }
          </div>
        </div>
      </Provider>)
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page,
    chat: state.chat,
    tournament: state.tournament
  }
}

const ConnectedChatComponent = connect(mapStateToProps)(ChatComponent)


export default ConnectedChatComponent;
