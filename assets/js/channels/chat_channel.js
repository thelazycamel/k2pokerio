class ChatChannel {

  constructor() {
    if(App.settings.tournament_id){
      this.joinChatChannel();
    }
  }

  joinChatChannel() {
    App.chatChannel = App.socket.channel("chat:" + App.settings.tournament_id);

    App.chatChannel.join().receive("ok", resp =>
      console.log("joined chat ok")
    ).receive("error", reason =>
      console.log("join failed")
    )

    App.chatChannel.on("chat:new_list", function(resp){
      App.store.dispatch({type: "CHAT:NEW_LIST_RECEIVED", comments: resp.comments});
    });

    App.chatChannel.on("chat:new_comment", function(resp) {
      App.store.dispatch({type: "CHAT:COMMENT_RECEIVED", comment: resp});
    });

  }

}

export default ChatChannel;
