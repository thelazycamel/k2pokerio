defmodule K2pokerIo.UpdateGameStatsTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.Commands.UserStats.UpdateGameStatsCommand

  doctest K2pokerIo.Commands.UserStats.UpdateGameStatsCommand

  setup do
    Helpers.advanced_set_up(["bob", "stu"])
  end

  test "it should update the winning user stats", context do
    player_id = User.player_id(context.player1)
    game = Helpers.player_wins(context.game, player_id)
    user_stats = UpdateGameStatsCommand.execute(game, player_id)
    assert(user_stats.games_played == 1)
    assert(user_stats.games_won == 1)
    assert(user_stats.games_lost == 0)
    assert(user_stats.games_folded == 0)
  end

  test "it should update the losing user stats", context do
    player_id = User.player_id(context.player1)
    game = Helpers.player_loses(context.game, player_id)
    user_stats = UpdateGameStatsCommand.execute(game, player_id)
    assert(user_stats.games_played == 1)
    assert(user_stats.games_won == 0)
    assert(user_stats.games_lost == 1)
    assert(user_stats.games_folded == 0)
  end

  test "it should update the drawing user stats", context do
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game = Helpers.players_draw(context.game, player1_id, player2_id)
    user_stats1 = UpdateGameStatsCommand.execute(game, player1_id)
    user_stats2 = UpdateGameStatsCommand.execute(game, player2_id)
    assert(user_stats1.games_played == 1)
    assert(user_stats1.games_won == 0)
    assert(user_stats1.games_lost == 0)
    assert(user_stats2.games_played == 1)
    assert(user_stats2.games_won == 0)
    assert(user_stats2.games_lost == 0)
  end

  test "it should update the user stats when player folds", context do
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game = Helpers.player_folds(context.game, player1_id)
    user_stats1 = UpdateGameStatsCommand.execute(game, player1_id)
    user_stats2 = UpdateGameStatsCommand.execute(game, player2_id)
    assert(user_stats1.games_played == 1)
    assert(user_stats1.games_folded == 1)
    assert(user_stats1.games_won == 0)
    assert(user_stats1.games_lost == 0)
    assert(user_stats2.games_played == 1)
    assert(user_stats2.games_folded == 0)
    assert(user_stats2.games_won == 0)
    assert(user_stats2.games_lost == 0)
  end

end
