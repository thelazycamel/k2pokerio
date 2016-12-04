defmodule K2pokerIo.UpdateScoresCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Fixtures.GameDataFixture
  alias K2pokerIo.Commands.Tournament.UpdateScoresCommand

  use K2pokerIo.ConnCase

  doctest K2pokerIo.Commands.Tournament.UpdateScoresCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

  #TODO move these tests somewhere else (testing the tests!)
  test "test setup", context do
    assert(context.player1.username == "bob")
    assert(context.player2.username == "stu")
    assert(context.game.player1_id == context.player1.player_id)
    assert(context.game.player2_id == context.player2.player_id)
  end

  test "it should double the score if the player has won", context do
    Helpers.set_scores(context.player1.player_id, context.player2.player_id, 64)
    Helpers.player_wins(context.game, context.player1.player_id)
    |> UpdateScoresCommand.execute()
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 128)
    assert(utd2.current_score == 1)
  end

  test "it should mark the players score as 1 if they have lost", context do
    Helpers.set_scores(context.player1.player_id, context.player2.player_id, 64)
    Helpers.player_loses(context.game, context.player1.player_id)
    |> UpdateScoresCommand.execute()
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 1)
    assert(utd2.current_score == 128)
  end

  test "it should keep the score the same if its a draw", context do
    Helpers.set_scores(context.player1.player_id, context.player2.player_id, 64)
    Helpers.players_draw(context.game, context.player1.player_id, context.player2.player_id)
    |> UpdateScoresCommand.execute()
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 64)
    assert(utd2.current_score == 64)
  end

  test "it should halve the players score if they have folded, and other players score should remain the same", context do
    Helpers.set_scores(context.player1.player_id, context.player2.player_id, 64)
    Helpers.player_folds(context.game, context.player1.player_id)
    |> UpdateScoresCommand.execute()
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 32)
    assert(utd2.current_score == 64)
  end

  test "it should keep the players score if the other player has folded", context do
    Helpers.set_scores(context.player1.player_id, context.player2.player_id, 64)
    Helpers.player_folds(context.game, context.player2.player_id)
    |> UpdateScoresCommand.execute()
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 64)
    assert(utd2.current_score == 32)
  end

  test "it should keep the players score at 1 if they fold on 1", context do
    Helpers.set_scores(context.player1.player_id, context.player2.player_id, 1)
    Helpers.player_folds(context.game, context.player1.player_id)
    |> UpdateScoresCommand.execute()
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 1)
    assert(utd2.current_score == 1)
  end

  test "it should do nothing if the player has already been paid out", context do
    Helpers.set_scores(context.player1.player_id, context.player2.player_id, 64)
    game = Helpers.player_wins(context.game, context.player1.player_id)
    |> UpdateScoresCommand.execute()
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 128)
    assert(utd2.current_score == 1)
    UpdateScoresCommand.execute(game)
    utd1 = Repo.get(UserTournamentDetail, context.player1.id)
    utd2 = Repo.get(UserTournamentDetail, context.player2.id)
    assert(utd1.current_score == 128)
    assert(utd2.current_score == 1)
  end

end

