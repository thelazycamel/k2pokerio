defmodule K2pokerIo.DestroyTournamentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Friendship
  alias K2pokerIo.Invitation
  alias K2pokerIo.User
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Tournament.DestroyTournamentCommand
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.DestroyTournamentCommand

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    player3 = Helpers.create_user("pip")
    player4 = Helpers.create_user("salma")
    #create friends
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player4.id, status: true}))
    friend_ids = Enum.join([player2.id, player3.id, player4.id], ",")
    #create the tournament
    {:ok, tournament} = CreateTournamentCommand.execute(player1, %{"game_type" => "tournament", "name" => "My Test Tournament", "friend_ids" => friend_ids})
    #create user_tournament_details
    Helpers.create_user_tournament_detail(User.player_id(player1), player1.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player2), player2.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player3), player3.username, tournament.id)
    %{player1: player1, player2: player2, player3: player3, player4: player4, tournament: tournament}
  end

  test "should destroy the tournament when the tournament owner is requesting it", context do
    DestroyTournamentCommand.execute(context.player1, context.tournament.id)
    refute(Repo.one(from t in Tournament, where: t.id == ^context.tournament.id))
  end

  test "should not destroy the tournament when someone else is requesting it", context do
    DestroyTournamentCommand.execute(context.player2, context.tournament.id)
    assert(Repo.one(from t in Tournament, where: t.id == ^context.tournament.id))
  end

  test "should destroy tournament when someone down to last 2 people", context do
    friend_ids = "#{context.player2.id}"
    {:ok, duel} = CreateTournamentCommand.execute(context.player1, %{"game_type" => "duel", "friend_ids" => friend_ids})
    assert(duel)
    DestroyTournamentCommand.execute(context.player2, duel.id)
    refute(Repo.one(from t in Tournament, where: t.id == ^duel.id))
  end

  test "should destroy all the invites", context do
    DestroyTournamentCommand.execute(context.player1, context.tournament.id)
    invites = Repo.all(from i in Invitation, where: i.id == ^context.tournament.id)
    assert(Enum.empty?(invites))
  end

  test "should destroy all the user_tournament_details", context do
    utds = Repo.all(from utd in UserTournamentDetail, where: [tournament_id: ^context.tournament.id], preload: [:game])
    assert(Enum.count(utds) == 3)
    DestroyTournamentCommand.execute(context.player1, context.tournament.id)
    utds = Repo.all(from utd in UserTournamentDetail, where: [tournament_id: ^context.tournament.id], preload: [:game])
    assert(Enum.count(utds) == 0)
  end

end
