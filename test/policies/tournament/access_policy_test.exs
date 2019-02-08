defmodule K2pokerIo.TournamentAccessPolicyTest do

  alias K2pokerIo.Repo
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Policies.Tournament.AccessPolicy

  import Ecto.Query

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Policies.Tournament.AccessPolicy

  setup do
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    player3 = Helpers.create_user("MrAngry")
    %{player1: player1, player2: player2, player3: player3}
  end

  test "should be accessible if open tournament", context do
    tournament = Helpers.create_tournament()
    assert(AccessPolicy.accessible?(context.player1, tournament))
  end

  test "should be accessible if invited", context do
    tournament = Helpers.create_private_tournament(context.player2, "I am accessible for player 1")
    Helpers.create_invitation(tournament.id, context.player1.id, true)
    assert(AccessPolicy.accessible?(context.player1, tournament))
  end

  test "should not be accessible as uninvited", context do
    tournament = Helpers.create_private_tournament(context.player3, "I should not be accessible for player 1")
    refute(AccessPolicy.accessible?(context.player1, tournament))
  end

  test "should not be accessible if finished", context do
    tournament = Repo.insert!(%Tournament{
      name: "Closing Tournament",
      default_tournament: false,
      private: false,
      tournament_type: "tournament",
      finished: false,
      user_id: context.player1.id,
      lose_type: "all",
      starting_chips: 1,
      max_score: 64,
      bots: true,
      rebuys: [0]
    })
    assert(AccessPolicy.accessible?(context.player1, tournament))
    tournament = Repo.update!(Tournament.changeset(tournament, %{finished: true}))
    refute(AccessPolicy.accessible?(context.player1, tournament))
  end

end
