defmodule K2pokerIo.CheckIdlePlayerCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.Game.PlayCommand
  alias K2pokerIo.Commands.Game.CheckIdlePlayerCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Game.CheckIdlePlayerCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

  test "it should not force play if the time is less than 15 seconds", context do
    player1_id = context.player1.player_id
    game = Repo.get(Game, context.game.id)
    Repo.update!(Game.changeset(game, %{p1_timestamp: Timex.now, p2_timestamp: Timex.now}))
    PlayCommand.execute(game.id, player1_id)
    {:ok, action} = CheckIdlePlayerCommand.execute(game.id, player1_id)
    assert(action == :no_change)
  end

  test "it should force play if the other player is idle", context do
    player1_id = context.player1.player_id
    game = Repo.get(Game, context.game.id)
    one_minute_ago = Timex.now |> Timex.shift(minutes: -1)
    Repo.update!(Game.changeset(game, %{p2_timestamp: one_minute_ago}))
    PlayCommand.execute(game.id, player1_id)
    {:ok, action} = CheckIdlePlayerCommand.execute(game.id, player1_id)
    assert(action == :forced_play)
  end

end

