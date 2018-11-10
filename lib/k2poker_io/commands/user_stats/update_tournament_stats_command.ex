defmodule K2pokerIo.Commands.UserStats.UpdateTournamentStatsCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.User
  alias K2pokerIo.UserStats
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo

  import Ecto.Query

  @doc "updates the user stats with tournament wins"

  def execute(utd) do
    unless UserTournamentDetail.is_anon_user?(utd.player_id) do
      find_or_create_user_stats(utd.player_id)
      |> update_user_stats(utd)
    end
  end

  defp find_or_create_user_stats(player_id) do
    {:user, user_id} = User.get_id(player_id)
    user_stats = Repo.one(from us in UserStats, where: us.user_id == ^user_id)
    user_stats || Repo.insert!(UserStats.changeset(%UserStats{}, user_stats_params(user_id)))
  end

  defp update_user_stats(user_stats, utd) do
    if utd.tournament.type == "duel" do
      duels_won = user_stats.duels_won + 1
      Repo.update(UserStats.changeset(user_stats, %{duels_won: duels_won}))
    else
      tournaments_won = user_stats.tournaments_won + 1
      Repo.update(UserStats.changeset(user_stats, %{tournaments_won: tournaments_won}))
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
