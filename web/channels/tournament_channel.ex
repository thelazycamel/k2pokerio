defmodule K2pokerIo.TournamentChannel do
  use K2pokerIo.Web, :channel
  alias K2pokerIo.Commands.Game.JoinCommand
  alias K2pokerIo.UserTournamentDetail

  def join("tournament:" <> tournament_id, _params, socket) do
    IO.puts "***** You are in the Tournament Channel for " <> tournament_id <> " *****"
    :timer.send_interval(20000, :ping)
    {:ok, socket}
  end

  def handle_info(:ping, socket) do
    count = socket.assigns[:count] || 1
    push socket, "ping", %{count: count}
    {:noreply, assign(socket, :count, count+1)}
  end


end