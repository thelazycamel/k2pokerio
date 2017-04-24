import React from "react"
import ReactDOM from "react-dom"

class Comment extends React.Component {

  componentDidMount() {
    let el = document.getElementById("comment-" +this.props.comment.id);
    el.scrollIntoView();
  }

  render() {
    return (
      <li className="chat-comment" id={"comment-"+this.props.comment.id}>
        <span className="chat-user">{this.props.comment.username}</span>
        <span className="chat-text">{this.props.comment.comment}</span>
      </li>
    )
  }
}

export default Comment;
