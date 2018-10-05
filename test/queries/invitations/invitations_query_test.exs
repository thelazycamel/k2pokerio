defmodule K2pokerIo.InvitationsQueryTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Invitation
  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Queries.Invitations.InvitationsQuery

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Queries.Invitations.InvitationsQuery

  setup do
    default_tournament = Helpers.create_tournament()
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    RequestFriendCommand.execute(player1.id, player2.id)
    RequestFriendCommand.execute(player2.id, player1.id)
    accepted_tournament = Helpers.create_private_tournament(player1, "Stus tourney")
    invited_tournament = Helpers.create_private_tournament(player2, "Bobs tourney")
    Repo.insert!(Invitation.changeset(%Invitation{}, %{ user_id: player1.id, tournament_id: accepted_tournament.id, accepted: true}))
    invite = Repo.insert!(Invitation.changeset(%Invitation{}, %{ user_id: player1.id, tournament_id: invited_tournament.id, accepted: false}))
    %{player1: player1,
      player2: player2,
      default_tournament: default_tournament,
      accepted_tournament: accepted_tournament,
      invited_tournament: invited_tournament,
      invite: invite
    }
  end

  test "#count should count the number of outstanding invitations for the user", context do
    assert(InvitationsQuery.count(context.player1.id) == 1)
  end

  test "#all should return all the invitations for the user", context do
    {invites, _} = InvitationsQuery.all(context.player1.id, %{page: 1, per_page: 7, max_pages: 100})
    invite = List.first(invites)
    assert(Enum.count(invites) == 1)
    assert(invite.name == "Bobs tourney")
  end

end
