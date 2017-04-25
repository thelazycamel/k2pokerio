import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'
import Comment from './presentational/comment'

class ChatComponent extends React.Component {

  handleKeyPress(e) {
    if(e.key == "Enter") {
      App.store.dispatch({type: "CHAT:CREATE_COMMENT", comment: e.currentTarget.value});
      e.currentTarget.value = "";
    }
  }

  renderComments() {
    if(this.props.chat.comments) {
      return this.props.chat.comments.map( (comment) =>
        <Comment comment={comment} key={comment.id} />
      )
    }
  }

  renderInput() {
    if(App.settings.logged_in == "true"){
      return <input type="text" className="logged-in" id="new-chat" onKeyPress={this.handleKeyPress.bind(this)} />
    } else {
      return <input type="text" id="new-chat" placeholder="Log in to join the conversation" disabled />
    }
 }

  render() {
    return (<Provider store={this.props.store}>
        <div id="chat-root" className={this.props.page.tabs["chat"]}>
          <div id="chat-inner">
            <h2>Tournament Name</h2>
            <ul id="chats">
            { this.renderComments() }
            </ul>
            { this.renderInput() }
          </div>
        </div>
      </Provider>)
  }
}

const mapStateToProps = (state) => {
  return {
    page: state.page,
    chat: state.chat
  }
}

const ConnectedChatComponent = connect(mapStateToProps)(ChatComponent)


export default ConnectedChatComponent;
