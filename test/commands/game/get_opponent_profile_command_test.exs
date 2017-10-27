defmodule K2pokerIo.GetOpponentProfileCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Game.GetOpponentProfileCommand

  use K2pokerIoWeb.ConnCase

  doctest K2pokerIo.Commands.Game.GetOpponentProfileCommand

  setup do
    Helpers.advanced_set_up(["stu", "bob"])
  end

  test "gets the opponents users profile given the current user", context do
    player2 = context.player2
    changeset = User.profile_changeset(player2, %{blurb: "Hello from your opponent"})
    Repo.update(changeset)

    opponent = GetOpponentProfileCommand.execute(context.game, context.p1_utd.player_id)
    assert(opponent.username == "bob")
    assert(opponent.opponent == "user")
    assert(opponent.blurb == "Hello from your opponent")

  end


end
