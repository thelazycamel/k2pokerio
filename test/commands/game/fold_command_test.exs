defmodule K2pokerIo.FoldCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.FoldCommand

  use K2pokerIoWeb.ConnCase, async: false

  doctest K2pokerIo.Commands.Game.FoldCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

  test "It should set the status' for the game", context do
    player1_id = context.player1.player_id
    player2_id = context.player2.player_id
    Helpers.set_scores(player1_id, player2_id, 128)
    FoldCommand.execute(context.game.id, player1_id)
    player1_data = Helpers.get_player_data(context.game.id, player1_id)
    player2_data = Helpers.get_player_data(context.game.id, player2_id)
    p1_utd = Repo.get_by(UserTournamentDetail, player_id: player1_id)
    p2_utd = Repo.get_by(UserTournamentDetail, player_id: player2_id)
    assert(player1_data.status == "finished")
    assert(player1_data.result.status == "folded")
    assert(player2_data.result.status == "other_player_folded")
    assert(p1_utd.current_score == 64)
    assert(p2_utd.current_score == 128)
  end

end
