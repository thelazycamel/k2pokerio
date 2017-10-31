defmodule K2pokerIo.DestroyTournamentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Friendship
  alias K2pokerIo.Invitation
  alias K2pokerIo.Commands.Tournament.DestroyTournamentCommand
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.DestroyTournamentCommand

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    player3 = Helpers.create_user("pip")
    player4 = Helpers.create_user("salma")
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player4.id, status: true}))
    friend_ids = Enum.join([player2.id, player3.id, player4.id], ",")
    tournament = CreateTournamentCommand.execute(player1, %{"game_type" => "tournament", "name" => "My Test Tournament", "friend_ids" => friend_ids})
    %{player1: player1, player2: player2, player3: player3, player4: player4, tournament: tournament}
  end

  test "should destroy the tournament when the tournament owner is requesting it", context do
    DestroyTournamentCommand.execute(context.player1, context.tournament.id)
    refute(Repo.one(from t in Tournament, where: t.id == ^context.tournament.id))
  end

end
