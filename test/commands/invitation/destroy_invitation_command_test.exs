defmodule K2pokerIo.DestroyInvitationCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Invitation
  alias K2pokerIo.Commands.Invitation.DestroyInvitationCommand

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Commands.Invitation.DestroyInvitationCommand

  setup do
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    player3 = Helpers.create_user("pip")
    player4 = Helpers.create_user("salma")
    tournament = Helpers.create_private_tournament(player1, "stus tourney")
    Repo.insert(Invitation.changeset(%Invitation{},
      %{
        user_id: player1.id,
        tournament_id: tournament.id,
        accepted: true
      }
    ))
    Repo.insert(Invitation.changeset(%Invitation{},
      %{
        user_id: player2.id,
        tournament_id: tournament.id,
        accepted: false
      }
    ))
    Repo.insert(Invitation.changeset(%Invitation{},
      %{
        user_id: player3.id,
        tournament_id: tournament.id,
        accepted: false
      }
    ))
    Repo.insert(Invitation.changeset(%Invitation{},
      %{
        user_id: player4.id,
        tournament_id: tournament.id,
        accepted: false
      }
    ))
    %{player1: player1, player2: player2, player3: player3, player4: player4, tournament: tournament}
  end

  test "it should destroy the invitation request", context do
    invite = Repo.one(from i in Invitation, where: i.user_id == ^context.player1.id)
    DestroyInvitationCommand.execute(context.player1, invite.id)
    refute(Repo.one(from i in Invitation, where: i.id == ^invite.id))
  end

  test "it should not destroy the invitation request with the wrong user", context do
    p2_invite = Repo.one(from i in Invitation, where: i.user_id == ^context.player2.id)
    DestroyInvitationCommand.execute(context.player3, p2_invite.id)
    response = Repo.one(from i in Invitation, where: i.id == ^p2_invite.id)
    assert(response.id == p2_invite.id)
  end

end

