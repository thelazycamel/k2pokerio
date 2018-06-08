import React from "react"
import ReactDOM from "react-dom"

class Comment extends React.Component {

  componentDidMount() {
    let el = document.getElementById("chats");
    if(el){
      el.scrollTop = el.scrollHeight;
    }
  }

  admin_class() {
    return this.props.comment.admin ? "admin" : "";
  }

  owner_comment_class() {
    return this.props.comment.owner ? "owner" : "";
  }

  comment_classes() {
    let classes = ["chat-comment", this.admin_class(), this.owner_comment_class()];
    return classes.join(" ");
  }

  showFriendMe() {
    // TODO: replace the current comment with friend status / friend me link,
    // or onclick again show comment
    // this should be passed to redux and held properly, not in state
    App.services.friends.status(this.props.comment.user_id).then(response => {
      console.log(response.status);
    })
  }

  chat_image() {
    if(!this.props.comment.admin && !this.props.comment.owner) {
      return(
        <div className="chat-user"
          title={this.props.comment.username}
          style={ {backgroundImage: "url('" + this.props.comment.image + "')"} }
          onClick={ this.showFriendMe.bind(this) }>
        </div>
       )
    }
  }

  render() {
    return (
      <div className={this.comment_classes()} id={"comment-"+this.props.comment.id}>
        { this.chat_image() }
        <div className="chat-text">
          <div className="username">{this.props.comment.username}</div>
          {this.props.comment.comment}
          <span className="quote"></span>
        </div>
      </div>
    )
  }
}

export default Comment;
