defmodule K2pokerIo.DiscardCommandTest do

  alias K2pokerIo.Fixtures.SetUp
  alias K2pokerIo.Game
  alias K2pokerIo.Repo

  use K2pokerIo.ConnCase

  doctest K2pokerIo.Commands.Game.DiscardCommand

  setup do
    SetUp.basic_set_up(["bob", "stu"])
  end

  test "#execute when player able to discard", context do
    player1_id = context.player1.player_id
    decoded_game = Game.decode_game_data(context.game.data)
    player1 = K2poker.player_data(decoded_game, player1_id)
    assert(player1.player_status == "new")
    assert(player1.status == "deal")
    K2pokerIo.Commands.Game.DiscardCommand.execute(context.game.id, player1_id, 0)
    reloaded_game = Repo.get(Game, context.game.id)
    new_decoded_game = Game.decode_game_data(reloaded_game.data)
    new_p1 = K2poker.player_data(new_decoded_game, player1_id)
    refute(List.first(new_p1.cards) == List.first(player1.cards))
    assert(List.last(new_p1.cards) == List.last(player1.cards))
  end

end

