defmodule K2pokerIo.ChatChannel do
  use K2pokerIo.Web, :channel

  def join("chat:" <> tournament_id, _params, socket) do
    IO.puts "***** You are in the Chat Channel for " <> tournament_id <> " *****"
    {:ok, socket}
  end

end
