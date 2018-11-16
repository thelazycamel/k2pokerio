defmodule K2pokerIo.Decorators.UserStatsDecorator do

  def decorate(user_stats) do
    if user_stats do
      user_stats(user_stats)
    else
      nil_user_stats
    end
  end

  defp user_stats(user_stats) do
    %{
      games_played:    user_stats.games_played,
      games_won:       user_stats.games_won,
      games_lost:      user_stats.games_lost,
      games_folded:    user_stats.games_folded,
      tournaments_won: user_stats.tournaments_won,
      duels_won:       user_stats.duels_won,
      top_score:       user_stats.top_score
    }
  end

  defp nil_user_stats do
    %{
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
