defmodule K2pokerIoWeb.TournamentChannel do

  use K2pokerIoWeb, :channel

  alias K2pokerIo.Tournament

  alias K2pokerIo.Queries.Tournaments.GetPlayersQuery

  def join("tournament:" <> tournament_id, _params, socket) do
    send self(), {:after_join, tournament_id}
    {:ok, socket}
  end

  def handle_info({:after_join, tournament_id}, socket) do
    broadcast! socket, "tournament:update", %{tournament_id: tournament_id}
    {:noreply, socket}
  end

  def handle_in("tournament:refresh_data", %{"tournament_id" => tournament_id}, socket) do
    {tournament_id, _} = Integer.parse(tournament_id)
    tournament = Repo.get(Tournament, tournament_id)
    player_id = socket.assigns[:player_id]
    player_count = GetPlayersQuery.count(tournament_id)
    push socket, "tournament:update",  %{player_count: player_count, tournament_name: tournament.name}
    {:noreply, socket}
  end

end
