defmodule K2pokerIo.UpdateScoreCommandTest do

  alias K2pokerIo.Fixtures.SetUp
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Fixtures.GameDataFixture
  alias K2pokerIo.Commands.Tournament.UpdateScoreCommand

  use K2pokerIo.ConnCase

  doctest K2pokerIo.Commands.Tournament.UpdateScoreCommand

  setup do
    SetUp.basic_set_up(["bob", "stu"])
  end

  test "test setup", context do
    assert(context.player1.username == "bob")
    assert(context.player2.username == "stu")
    assert(context.game.player1_id == context.player1.player_id)
    assert(context.game.player2_id == context.player2.player_id)
  end

  test "it should double the score if the player has won", context do
    {:ok, player1} = UserTournamentDetail.changeset(context.player1, %{current_score: 64}) |> Repo.update()
    player_id = player1.player_id
    GameDataFixture.player_wins(context.game, player_id)
    |> UpdateScoreCommand.execute(player_id)
    utd = Repo.get(UserTournamentDetail, player1.id)
    assert(utd.current_score == 128)
  end

  test "it should mark the players score as 1 if they have lost", context do
    {:ok, player1} = UserTournamentDetail.changeset(context.player1, %{current_score: 64}) |> Repo.update()
    player_id = player1.player_id
    GameDataFixture.player_loses(context.game, player_id)
    |> UpdateScoreCommand.execute(player_id)
    utd = Repo.get(UserTournamentDetail, player1.id)
    assert(utd.current_score == 1)
  end

  test "it should keep the score the same if its a draw", context do
    {:ok, player1} = UserTournamentDetail.changeset(context.player1, %{current_score: 64}) |> Repo.update()
    {:ok, player2} = UserTournamentDetail.changeset(context.player2, %{current_score: 64}) |> Repo.update()
    game = GameDataFixture.players_draw(context.game, player1.player_id, player2.player_id)
    UpdateScoreCommand.execute(game, player2.player_id)
    UpdateScoreCommand.execute(game, player1.player_id)
    utd1 = Repo.get(UserTournamentDetail, player1.id)
    utd2 = Repo.get(UserTournamentDetail, player1.id)
    assert(utd1.current_score == 64)
    assert(utd2.current_score == 64)
  end

  test "it should halve the players score if they have folded, and other players score should remain the same", context do
    {:ok, player1} = UserTournamentDetail.changeset(context.player1, %{current_score: 64}) |> Repo.update()
    {:ok, player2} = UserTournamentDetail.changeset(context.player2, %{current_score: 64}) |> Repo.update()
    game = GameDataFixture.player_folds(context.game, player1.player_id)
    UpdateScoreCommand.execute(game, player1.player_id)
    UpdateScoreCommand.execute(game, player2.player_id)
    utd1 = Repo.get(UserTournamentDetail, player1.id)
    utd2 = Repo.get(UserTournamentDetail, player2.id)
    assert(utd1.current_score == 32)
    assert(utd2.current_score == 64)
  end

  test "it should keep the players score at 1 if they fold on 1", context do
    {:ok, player1} = UserTournamentDetail.changeset(context.player1, %{current_score: 1}) |> Repo.update()
    {:ok, player2} = UserTournamentDetail.changeset(context.player2, %{current_score: 1}) |> Repo.update()
    game = GameDataFixture.player_folds(context.game, player1.player_id)
    UpdateScoreCommand.execute(game, player1.player_id)
    UpdateScoreCommand.execute(game, player2.player_id)
    utd1 = Repo.get(UserTournamentDetail, player1.id)
    utd2 = Repo.get(UserTournamentDetail, player2.id)
    assert(utd1.current_score == 1)
    assert(utd2.current_score == 1)
  end

  test "it should do nothing if the player has already been paid out", context do
    {:ok, player1} = UserTournamentDetail.changeset(context.player1, %{current_score: 64}) |> Repo.update()
    player_id = player1.player_id
    game = GameDataFixture.player_wins(context.game, player_id)
    UpdateScoreCommand.execute(game, player_id)
    utd = Repo.get(UserTournamentDetail, player1.id)
    assert(utd.current_score == 128)
    UpdateScoreCommand.execute(game, player_id)
    assert(utd.current_score == 128)
  end

end

