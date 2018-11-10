defmodule K2pokerIo.UpdateTopScoreTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.UserStats
  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.UserStats.UpdateTopScoreCommand

  doctest K2pokerIo.Commands.UserStats.UpdateTopScoreCommand

  setup do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("stu")
    utd = Helpers.create_user_tournament_detail(User.player_id(player), player.username, tournament.id)
    user_stats = Helpers.create_user_stats(player)
    %{player: player, user_stats: user_stats, utd: utd}
  end

  test "it should update the score if it is bigger than current top score", context do
    {:ok, user_stats} = UpdateTopScoreCommand.execute(2, context.utd)
    assert(user_stats.top_score == 2)
  end

  test "it should not update the score if its less than current score", context do
    Repo.update!(UserStats.changeset(context.user_stats, %{top_score: 512}))
    {:ok, user_stats} = UpdateTopScoreCommand.execute(128, context.utd)
    assert(user_stats.top_score == 512)
  end

  @tag :skip
  test "it should not update the score if its an anon user", context do
  end

  @tag :skip
  test "it should not update the score if its not the default tournament", context do
  end

end
