defmodule K2pokerIo.InvitationTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Invitation
  alias K2pokerIo.Tournament
  alias K2pokerIo.Test.Helpers

  doctest K2pokerIo.Invitation

  setup do
    player = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    params = %{
      name: "Test Tournament",
      private: true,
      tournament_type: "tournament",
      lose_type: "all",
      user_id: player.id,
      rebuys: [0],
    }
    changeset = Tournament.changeset(%Tournament{}, params)
    tournament = Repo.insert!(changeset) |> Repo.preload(:user)
    %{tournament: tournament, player: player, player2: player2}
  end

  test "changeset should validate tournament_id", context do
    params = %{tournament_id: nil, user_id: context.player.id, accepted: false}
    changeset = Invitation.changeset(%Invitation{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:tournament_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "changeset should validate user_id", context do
    params = %{tournament_id: context.tournament.id, user_id: nil, accepted: false}
    changeset = Invitation.changeset(%Invitation{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:user_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

end
