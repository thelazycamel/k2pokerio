defmodule K2pokerIo.UpdateScoreCommandTest do

  alias K2pokerIo.Fixtures.SetUp
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Game
  alias K2pokerIo.Fixtures.GameDataFixture
  alias K2pokerIo.Commands.Tournament.UpdateScoreCommand

  use K2pokerIo.ConnCase

  doctest K2pokerIo.Commands.Tournament.UpdateScoreCommand

  setup do
    %{player1: player1, player2: player2, game: game} = SetUp.basic_set_up(["bob", "stu"])

    %{player1: player1, player2: player2, game: game}
  end

  test "test setup", context do
    assert(context.player1.username == "bob")
    assert(context.player2.username == "stu")
    assert(context.game.player1_id == context.player1.player_id)
    assert(context.game.player2_id == context.player2.player_id)
  end

  test "it should double the score if the player has won", context do
    #set score to 64
    p1_changeset = UserTournamentDetail.changeset(context.player1, %{current_score: 64})
    {:ok, player1} = Repo.update(p1_changeset)
    player_id = player1.player_id
    # fix the game data so the player wins
    game_data = GameDataFixture.player_wins(player_id)
    encoded_game_data = Poison.encode!(game_data)
    changeset = Game.changeset(context.game, %{data: encoded_game_data})
    {:ok, game} = Repo.update(changeset)
    # Run the Update Score command
    decoded_game_data = Game.decode_game_data(game.data)
    players_game_data = K2poker.player_data(decoded_game_data, player_id)
    UpdateScoreCommand.execute(game, player_id, players_game_data)
    utd = Repo.get(UserTournamentDetail, context.player1.id)
    assert(utd.current_score == 128)
  end

  test "it should mark the players score as 1 if they have lost" do

  end

  test "it should keep the score the same if its a draw" do

  end

  test "it should halve the players score if they have folded" do

  end

  test "it should keep the players score the same if the other has folded" do

  end

  test "it should do nothing if the player has already been paid out", context do

  end


end

