defmodule K2pokerIo.AcceptInvitationCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Invitation
  alias K2pokerIo.Commands.Invitation.AcceptInvitationCommand

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Commands.Invitation.AcceptInvitationCommand

  setup do
    Helpers.advanced_set_up(["bob", "stu"])
  end

  test "it should accept an invitation request", context do
    changeset = Invitation.changeset(%Invitation{},
      %{
        user_id: context.player1.id,
        tournament_id: context.tournament.id,
        accepted: false
      }
    )
    {:ok, invite} = Repo.insert(changeset)
    {:ok, accepted_invite} = AcceptInvitationCommand.execute(context.player1, invite.id)
    assert(accepted_invite.accepted == true)
  end

end

