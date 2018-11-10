defmodule K2pokerIo.UpdateTournamentStatsTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.UserStats
  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.UserStats.UpdateTournamentStatsCommand

  doctest K2pokerIo.Commands.UserStats.UpdateTournamentStatsCommand

  setup do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("stu")
    utd = Helpers.create_user_tournament_detail(User.player_id(player), player.username, tournament.id)
    user_stats = Helpers.create_user_stats(player)
    %{player: player, user_stats: user_stats, utd: utd}
  end

  @tag :skip
  test "it should update the tournaments won", context do
  end

  @tag :skip
  test "it should update the duels won", context do
  end

  @tag :skip
  test "it should not update the score if its an anon user", context do
  end

end
