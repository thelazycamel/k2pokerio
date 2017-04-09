import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class ChatComponent extends React.Component {

  render() {
    return (<Provider store={this.props.store}>
        <div id="chat-root" className={this.props.page.tabs["chat"]}>
          <div id="chat-inner">
            <h2>Tournament Name</h2>
            <ul id="chats">
              <li><span className="chat-user">Bob</span><span className="chat-text">This is a comment This is a comment This is a comment This is a comment This is a comment This is a comment</span></li>
              <li><span className="chat-user">Fred</span><span className="chat-text">This is another comment</span></li>
              <li><span className="chat-user">Bob</span><span className="chat-text">This is a comment</span></li>
              <li><span className="chat-user">Fred</span><span className="chat-text">This is another comment</span></li>
              <li><span className="chat-user">Bob</span><span className="chat-text">This is a comment</span></li>
              <li><span className="chat-user">Fred</span><span className="chat-text">This is another comment</span></li>
              <li><span className="chat-user">Bob</span><span className="chat-text">This is a comment</span></li>
              <li><span className="chat-user">Fred</span><span className="chat-text">This is another comment</span></li>
              <li><span className="chat-user">Bob</span><span className="chat-text">This is a comment</span></li>
              <li><span className="chat-user">Fred</span><span className="chat-text">This is another comment</span></li>
              <li><span className="chat-user">Bob</span><span className="chat-text">This is a comment</span></li>
              <li><span className="chat-user">Fred</span><span className="chat-text">This is another comment</span></li>
            </ul>
            <input type="text" id="new-chat" placeholder=">"/>
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
