defmodule K2pokerIo.PlayersUnfinishedTournamentsQueryTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Queries.Tournaments.PlayersUnfinishedTournamentsQuery

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Queries.Tournaments.PlayersUnfinishedTournamentsQuery

  setup do
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    RequestFriendCommand.execute(player1.id, player2.id)
    RequestFriendCommand.execute(player2.id, player1.id)
    %{player1: player1, player2: player2}
  end

  test "it should return all the duels that are unfinished", context do
    duel = Helpers.create_duel(context.player1, context.player2)
    Helpers.create_invitation(duel.id, context.player1.id, true)
    Helpers.create_invitation(duel.id, context.player2.id, false)
    assert(Enum.member?(PlayersUnfinishedTournamentsQuery.unfinished_duels(context.player1.id), duel.id))
    assert(Enum.member?(PlayersUnfinishedTournamentsQuery.unfinished_duels(context.player2.id), duel.id))
  end

  test "it should not return duels that are finished", context do
    duel = Helpers.create_duel(context.player1, context.player2)
    Helpers.create_invitation(duel.id, context.player1.id, true)
    Helpers.create_invitation(duel.id, context.player2.id, false)
    {:ok, duel} = Repo.update(Tournament.changeset(duel, %{finished: true}))

    refute(Enum.member?(PlayersUnfinishedTournamentsQuery.unfinished_duels(context.player1.id), duel.id))
    refute(Enum.member?(PlayersUnfinishedTournamentsQuery.unfinished_duels(context.player2.id), duel.id))
  end

  test "it should not return tournaments", context do
    tournament = Helpers.create_private_tournament(context.player1, "My Test Tourney")
    Helpers.create_invitation(tournament.id, context.player1.id, true)
    Helpers.create_invitation(tournament.id, context.player2.id, false)
    refute(Enum.member?(PlayersUnfinishedTournamentsQuery.unfinished_duels(context.player1.id), tournament.id))
    refute(Enum.member?(PlayersUnfinishedTournamentsQuery.unfinished_duels(context.player2.id), tournament.id))
  end

end
