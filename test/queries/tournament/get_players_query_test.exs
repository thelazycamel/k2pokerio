defmodule K2pokerIo.GetPlayersQueryTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.Friendship
  alias K2pokerIo.Queries.Tournaments.GetPlayersQuery
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand
  alias K2pokerIo.Commands.Tournament.JoinTournamentCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Queries.Tournaments.GetPlayersQuery

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    player3 = Helpers.create_user("pip")
    player4 = Helpers.create_user("salma")
    player5 = Helpers.create_user("fred")
    #create friends
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player4.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player5.id, status: true}))
    friend_ids = [player2.id, player3.id, player4.id, player5.id]
    {:ok, tournament} = CreateTournamentCommand.execute(player1, %{"game_type" => "tournament", "name" => "My Test Tournament", "friend_ids" => friend_ids})
    Helpers.create_user_tournament_detail(User.player_id(player1), player1.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player2), player2.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player3), player3.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player4), player4.username, tournament.id)
    %{tournament: tournament}
  end

  test "#count should return the number of players currently in the tournament", context do
    assert(GetPlayersQuery.count(context.tournament.id) == 4)
  end

  test "#all should return all the players in the tournament and their status", context do
    response = GetPlayersQuery.all(context.tournament.id)
    assert(Enum.count(response) == 5)
    p1 = Enum.find(response, fn(x) -> x.username == "bob" end)
    p2 = Enum.find(response, fn(x) -> x.username == "stu" end)
    p3 = Enum.find(response, fn(x) -> x.username == "pip" end)
    p4 = Enum.find(response, fn(x) -> x.username == "salma" end)
    p5 = Enum.find(response, fn(x) -> x.username == "fred" end)
    assert(p1.last_seen)
    assert(p2.last_seen)
    assert(p3.last_seen)
    assert(p4.last_seen)
    assert(p5.invite)
  end

  test "#all should return images for logged in players" do
    tournament = Helpers.create_tournament()
    Helpers.create_user_tournament_detail("anon", tournament.id)
    player = Repo.get_by(User, username: "stu")
      |> User.profile_changeset(%{image: "tester.png"})
      |> Repo.update!()
    JoinTournamentCommand.execute(player, tournament.id)
    response = GetPlayersQuery.all(tournament.id)
    p1 = Enum.find(response, fn(x) -> x.username == "anon" end)
    p2 = Enum.find(response, fn(x) -> x.username == "stu" end)
    assert(Enum.count(response) == 2)
    refute(p1.image)
    assert(p2.image == "tester.png")
  end

end
