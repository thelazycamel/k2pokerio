defmodule K2pokerIo.DiscardCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.Game.DiscardCommand

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Commands.Game.DiscardCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

  test "#execute when player able to discard", context do
    player1_id = context.player1.player_id
    decoded_game = Game.decode_game_data(context.game.data)
    player1 = K2poker.player_data(decoded_game, player1_id)
    assert(player1.player_status == "new")
    assert(player1.status == "deal")
    DiscardCommand.execute(context.game.id, player1_id, 0)
    reloaded_game = Repo.get(Game, context.game.id)
    new_decoded_game = Game.decode_game_data(reloaded_game.data)
    new_p1 = K2poker.player_data(new_decoded_game, player1_id)
    refute(List.first(new_p1.cards) == List.first(player1.cards))
    assert(List.last(new_p1.cards) == List.last(player1.cards))
    #it should update the timestamp for p1
    assert(reloaded_game.p1_timestamp != context.game.p1_timestamp)
    #it should not update the timestamp for p2
    assert(reloaded_game.p2_timestamp == context.game.p2_timestamp)
  end

end

