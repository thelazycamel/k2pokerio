defmodule K2pokerIo.Queries.Tournaments.GetWinnersQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail

  import Ecto.Query

  def current_winners(player_id, tournament) do
    %{
      current_player: current_players_utd(player_id, tournament),
      other_player: get_winner(player_id, tournament)
     }
  end

  defp get_winner(player_id, tournament) do
    winner = winner_or_other_players_utd(player_id, tournament)
    case winner do
      nil -> %{username: "Waiting", current_score: 1}
      _ -> winner
    end
  end

  #TODO check where updated_at is today, to make sure we only
  # return todays highest (possibly could be in the last hour!)

  defp winner_or_other_players_utd(player_id, tournament) do
    query = from utd in UserTournamentDetail,
      select: %{username: utd.username, current_score: utd.current_score},
      where: utd.tournament_id == ^tournament.id,
      where: not(utd.player_id == ^player_id),
      order_by: [desc: :current_score],
      limit: 1
    Repo.one(query)
  end

  defp current_players_utd(player_id, tournament) do
    query = from utd in UserTournamentDetail,
      select: %{username: utd.username, current_score: utd.current_score},
      where: utd.tournament_id == ^tournament.id and utd.player_id == ^player_id
    Repo.one(query)
  end


end
