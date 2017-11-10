defmodule K2pokerIo.GetPlayersQueryTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.Friendship
  alias K2pokerIo.Queries.Tournaments.GetPlayersQuery
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Queries.Tournaments.GetPlayersQuery

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
    tournament = CreateTournamentCommand.execute(player1, %{"game_type" => "tournament", "name" => "My Test Tournament", "friend_ids" => friend_ids})
    Helpers.create_user_tournament_detail(User.player_id(player1), player1.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player2), player2.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player3), player3.username, tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(player4), player4.username, tournament.id)
    %{tournament: tournament}
  end

  test "should return the number of players currently in the tournament", context do
    assert(GetPlayersQuery.count(context.tournament.id) == 4)
  end

end
