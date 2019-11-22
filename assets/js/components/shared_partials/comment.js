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
    let { comment } = this.props;
    if(this.props.comment.show == "comment") {
      App.services.friends.status(this.props.comment.user_id).then(data => {
        App.store.dispatch({ type: "CHAT:UPDATE_SHOW_STATUS", comment: {...comment, data}} );
      });
    } else {
      App.store.dispatch({ type: "CHAT:UPDATE_SHOW_STATUS", comment: {...comment, show: "comment"} });
    }
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

  sendFriendRequest(){
    let { comment } = this.props;
    App.services.friends.create({id: comment.user_id}).then(response => {
      let show = response.friend;
      if(response.badges.length > 0) {
        App.page.showBadgeAlert(response.badges);
      }
      App.store.dispatch({type: "CHAT:UPDATE_SHOW_STATUS", comment: {...comment, show: show} });
    })
  }

  renderCommentOrStatus() {
    switch(this.props.comment.show){
        case "friend":
          return App.t("friend");
          break;
        case "pending_me":
          return <a className="friend-request" onClick={this.sendFriendRequest.bind(this)}>{ App.t("confirm_friend") }</a>
          break;
        case "pending_them":
          return App.t("pending_them");
          break;
        case "not_friends":
          return <a className="friend-request" onClick={this.sendFriendRequest.bind(this)}>{ App.t("add_friend") }</a>
          break;
        default:
          return this.props.comment.comment;
          break;
    }
  }

  render() {
    return (
      <div className={this.comment_classes()} id={"comment-"+this.props.comment.chat_id}>
        { this.chat_image() }
        <div className="chat-text">
          <div className="username">{this.props.comment.username}</div>
          { this.renderCommentOrStatus() }
          <span className="quote"></span>
        </div>
      </div>
    )
  }
}

export default Comment;
