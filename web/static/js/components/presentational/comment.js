import React from "react"
import ReactDOM from "react-dom"

class Comment extends React.Component {

  componentDidMount() {
    let el = document.getElementById("chats");
    el.scrollTop = el.scrollHeight;
  }

  admin_class() {
    return this.props.comment.admin ? "admin" : "";
  }

  render() {
    return (
      <li className={"chat-comment " + this.admin_class()} id={"comment-"+this.props.comment.id}>
        <span className="chat-user">{this.props.comment.username}</span>
        <span className="chat-text">{this.props.comment.comment}</span>
      </li>
    )
  }
}

export default Comment;
