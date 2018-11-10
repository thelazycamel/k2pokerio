defmodule K2pokerIo.Commands.UserStats.UpdateGameStatsCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.User
  alias K2pokerIo.UserStats
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo

  import Ecto.Query

  @doc "updates the user stats with latest game results"

  def execute(game, player_id) do
    unless UserTournamentDetail.is_anon_user?(player_id) do
      find_or_create_user_stats(player_id)
      |> update_user_stats(game, player_id)
    end
  end

  defp find_or_create_user_stats(player_id) do
    {:user, user_id} = User.get_id(player_id)
    user_stats = Repo.one(from us in UserStats, where: us.user_id == ^user_id)
    user_stats || Repo.insert!(UserStats.changeset(%UserStats{}, user_stats_params(user_id)))
  end

  defp update_user_stats(user_stats, game, player_id) do
    result = get_result(game, player_id)

    updated_params = %{
      games_played: user_stats.games_played + 1,
      games_won: calculate_games_won(user_stats.games_won, result),
      games_lost: calculate_games_lost(user_stats.games_lost, result),
      games_folded: calculate_games_folded(user_stats.games_folded, result)
    }
    Repo.update!(UserStats.changeset(user_stats, updated_params))
  end

  defp calculate_games_won(games_won, result) do
    if result == "win" || result == "other_player_folded", do: games_won + 1, else: games_won
  end

  defp calculate_games_lost(games_lost, result) do
    if result == "lose", do: games_lost + 1, else: games_lost
  end

  defp calculate_games_folded(games_folded, result) do
    if result == "folded", do: games_folded + 1, else: games_folded
  end

  defp get_result(game, player_id) do
    player_data = get_player_data(game, player_id)
    player_data.result.status
  end

  defp get_player_data(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.player_data(player_id)
  end

  defp user_stats_params(user_id) do
    %{
      user_id: user_id,
      games_played: 0,
      games_won: 0,
      games_lost: 0,
      games_folded: 0,
      tournaments_won: 0,
      duels_won: 0,
      top_score: 0
    }
  end


end
