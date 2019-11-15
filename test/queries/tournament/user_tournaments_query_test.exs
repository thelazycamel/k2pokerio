defmodule K2pokerIo.UserTournamentsTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Invitation
  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Queries.Tournaments.UserTournamentsQuery

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Queries.Tournaments.UserTournamentsQuery

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

  test "it should all available tournaments", context do
    query = UserTournamentsQuery.all(context.player1, %{page_number: 1, page_size: 7})
    default_tourney = List.first(query.entries)
    accepted_tourney = List.last(query.entries)
    assert(Enum.count(query.entries) == 2)
    assert(default_tourney.current_score == nil)
    assert(default_tourney.starting_chips == 1)
    assert(default_tourney.name == context.default_tournament.name)
    assert(accepted_tourney.name == context.accepted_tournament.name)
  end

end
