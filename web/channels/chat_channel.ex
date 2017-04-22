defmodule K2pokerIo.ChatChannel do
  use K2pokerIo.Web, :channel
  alias K2pokerIo.Chat

  def join("chat:" <> tournament_id, _params, socket) do
    IO.puts "***** You are in the Chat Channel for " <> tournament_id <> " *****"
    comments = Chat.get_ten_comments(tournament_id)
    {:ok, socket, comments}
  end

  def handle_in("chat:new_comment", params, socket) do
    IO.puts params[:comment]
    {:ok, socket}
  end

end
