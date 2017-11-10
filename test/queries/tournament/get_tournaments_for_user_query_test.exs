defmodule K2pokerIo.GetTournamentsForUserQueryTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Invitation
  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Queries.Tournaments.GetTournamentsForUserQuery

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Queries.Tournaments.GetTournamentsForUserQuery

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

  test "it should return an array of tournaments", context do
    query = GetTournamentsForUserQuery.for_user(context.player1)
    expected = %{
      current: [
        %{
          current_score: 1,
          id: context.accepted_tournament.id,
          name: context.accepted_tournament.name
        }
      ],
      invites: [
        %{
          id: context.invite.id,
          name: context.invited_tournament.name,
          tournament_id: context.invited_tournament.id,
          username: context.player2.username
        }
      ],
      public: [
        %{
          current_score: 1,
          id: context.default_tournament.id,
          name: context.default_tournament.name
        }
      ]
    }
    assert(query == expected)
  end

end
