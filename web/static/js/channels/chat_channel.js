class ChatChannel {

  constructor(tournamentId) {
    this.joinChatChannel(tournamentId)
  }

  joinChatChannel(tournamentId) {
    App.chatChannel = App.socket.channel("chat:" + tournamentId);

    App.chatChannel.join().receive("ok", resp =>
      console.log(`initialized the Chat channel for Tournament: ${tournamentId}`)
    ).receive("error", reason =>
      console.log("join failed")
    )
  }

}

export default ChatChannel;
