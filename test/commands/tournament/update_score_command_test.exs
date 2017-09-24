defmodule K2pokerIo.UpdateScoresCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIoWeb.Commands.Game.JoinCommand
  alias K2pokerIoWeb.Commands.Game.RequestBotCommand
  alias K2pokerIoWeb.Commands.Game.FoldCommand
  alias K2pokerIoWeb.Commands.Tournament.UpdateScoresCommand

  use K2pokerIoWeb.ConnCase

  doctest K2pokerIoWeb.Commands.Tournament.UpdateScoresCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

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

  test "It should not try and update score if bot" do
    tournament = Helpers.create_tournament
    p1_utd = Helpers.create_user_tournament_detail("bob", tournament.id)
    {:ok, game} = JoinCommand.execute(p1_utd)
    {:ok, game} = RequestBotCommand.execute(game.id)
    FoldCommand.execute(game.id, p1_utd.player_id)
    UpdateScoresCommand.execute(game)
    assert(p1_utd.current_score == 1)
  end

end

