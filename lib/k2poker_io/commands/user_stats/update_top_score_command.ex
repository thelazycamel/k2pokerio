defmodule K2pokerIo.Commands.UserStats.UpdateTopScoreCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.User
  alias K2pokerIo.UserStats
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo

  import Ecto.Query

  @doc "updates the user stats with top score"

  def execute(score, utd) do
    cond do
      UserTournamentDetail.is_anon_user?(utd.player_id) -> {:ok, "nothing to update"}
      !utd.tournament.default_tournament -> {:ok, "nothing to update"}
      true -> check_and_update_score(score, utd.player_id)
    end
  end

  def check_and_update_score(score, player_id) do
    find_or_create_user_stats(player_id)
    |> update_user_stats(score, player_id)
  end

  defp find_or_create_user_stats(player_id) do
    {:user, user_id} = User.get_id(player_id)
    user_stats = Repo.one(from us in UserStats, where: us.user_id == ^user_id)
    user_stats || Repo.insert!(UserStats.changeset(%UserStats{}, user_stats_params(user_id)))
  end

  defp update_user_stats(user_stats, score, player_id) do
    if score > user_stats.top_score do
      Repo.update(UserStats.changeset(user_stats, %{top_score: score}))
    else
      {:ok, user_stats}
    end
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
