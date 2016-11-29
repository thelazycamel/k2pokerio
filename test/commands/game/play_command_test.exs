defmodule K2pokerIo.PlayCommandTest do

  alias K2pokerIo.Fixtures.SetUp
  alias K2pokerIo.Game
  alias K2pokerIo.Repo

  use K2pokerIo.ConnCase

  doctest K2pokerIo.Commands.Game.PlayCommand

  setup do
    SetUp.basic_set_up(["bob", "stu"])
  end

  test "#execute play the next stage for the player", context do
    player1_id = context.player1.player_id
    decoded_game = Game.decode_game_data(context.game.data)
    player1 = K2poker.player_data(decoded_game, player1_id)
    assert(player1.player_status == "new")
    K2pokerIo.Commands.Game.PlayCommand.execute(context.game.id, player1_id)
    reloaded_game = Repo.get(Game, context.game.id)
    new_decoded_game = Game.decode_game_data(reloaded_game.data)
    new_p1 = K2poker.player_data(new_decoded_game, player1_id)
    assert(new_p1.player_status == "ready")
  end

end

