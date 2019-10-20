defmodule K2pokerIo.GetDataCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Game.GetDataCommand

  use K2pokerIoWeb.ConnCase, async: false

  doctest K2pokerIo.Commands.Game.GetDataCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

  test "it should get the game data for player 1", context do
    game = Helpers.on_the_flop(context.game)
    game_data = GetDataCommand.execute(game.id, game.player1_id)
    assert(game_data.cards == ["As", "Ac"])
    assert(game_data.table_cards == ["Ad", "Ah", "3d"])
    assert(game_data.status == "flop")
    assert(game_data.player_status == "new")
    assert(game_data.other_player_status == "new")
    assert(game_data.hand_description == "four_of_a_kind")
    assert(game_data.best_cards == ["Ac", "As", "3d", "Ah", "Ad"])
  end

  test "it should get the game data for player 2", context do
    game = Helpers.on_the_flop(context.game)
    game_data = GetDataCommand.execute(game.id, game.player2_id)
    assert(game_data.cards == ["2s", "3c"])
    assert(game_data.table_cards == ["Ad", "Ah", "3d"])
    assert(game_data.status == "flop")
    assert(game_data.player_status == "new")
    assert(game_data.other_player_status == "new")
    assert(game_data.hand_description == "two_pair")
    assert(game_data.best_cards == ["3c", "2s", "3d", "Ah", "Ad"])
  end

  test "it should get the final result for player 1", context do
    game = Helpers.player_wins(context.game, context.player1.player_id)
    game_data = GetDataCommand.execute(game.id, game.player1_id)
    assert(game_data.status == "finished")
    result = game_data.result
    assert(result.status == "win")
    assert(result.winning_cards == ["As", "Ac", "Ad", "Ah", "4h"])
    assert(result.win_description == "four_of_a_kind")
    assert(result.lose_description == "two_pair")
    assert(result.player_cards == ["As", "Ac"])
    assert(result.other_player_cards == ["2s", "3c"])
    assert(result.table_cards == ["Ad", "Ah", "3d", "2c", "4h"])
  end

  test "it should get the final result for player 2", context do
    game = Helpers.player_wins(context.game, context.player1.player_id)
    game_data = GetDataCommand.execute(game.id, game.player2_id)
    assert(game_data.status == "finished")
    result = game_data.result
    assert(result.status == "lose")
    assert(result.winning_cards == ["As", "Ac", "Ad", "Ah", "4h"])
    assert(result.win_description == "four_of_a_kind")
    assert(result.lose_description == "two_pair")
    assert(result.player_cards == ["2s", "3c"])
    assert(result.other_player_cards == ["As", "Ac"])
    assert(result.table_cards == ["Ad", "Ah", "3d", "2c", "4h"])
  end

  test "should return fold as true for tournament", context do
    game = Helpers.player_wins(context.game, context.player1.player_id)
    game_data = GetDataCommand.execute(game.id, game.player2_id)
    assert(game_data.fold)
  end

  test "should return fold as false when set in utd for duel" do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    player_id = User.player_id(player1)
    duel = Helpers.create_duel(player1, player2)
    p1_utd = Helpers.create_user_tournament_detail(player_id, player1.username, duel.id)
    p2_utd = Helpers.create_user_tournament_detail(User.player_id(player2), player2.username, duel.id)
    game = Helpers.create_game([p1_utd, p2_utd])
    |> Helpers.player_folds(User.player_id(player1))
    game_data = GetDataCommand.execute(game.id, player_id)
    assert(game_data.fold == false)
  end

end
