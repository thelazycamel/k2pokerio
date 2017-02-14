import React from "react"
import ReactDOM from "react-dom"
import { Provider } from 'react-redux'
import { connect } from 'react-redux'

class ChatComponent extends React.Component {

  render() {
    return (<Provider store={this.props.store}>
        <div id="chat-component">
          <h2>Chat</h2>
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
      </Provider>)
  }
}

const mapStateToProps = (state) => {
  return {
    chat: state.chat
  }
}

const ConnectedChatComponent = connect(mapStateToProps)(ChatComponent)


export default ConnectedChatComponent;
