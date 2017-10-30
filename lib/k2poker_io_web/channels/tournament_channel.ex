defmodule K2pokerIoWeb.TournamentChannel do

  use K2pokerIoWeb, :channel

  alias K2pokerIo.Tournament

  alias K2pokerIo.Commands.Tournament.GetPlayerCountCommand

  def join("tournament:" <> tournament_id, _params, socket) do
    send self(), {:after_join, tournament_id}
    {:ok, socket}
  end

  def handle_info({:after_join, tournament_id}, socket) do
    {tournament_id, _} = Integer.parse(tournament_id)
    player_count = GetPlayerCountCommand.execute(tournament_id)
    tournament_name = Repo.get(Tournament, tournament_id).name
    broadcast! socket, "tournament:update", %{player_count: player_count, tournament_name: tournament_name}
    {:noreply, socket}
  end

end
