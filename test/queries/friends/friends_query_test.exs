defmodule K2pokerIo.FriendsQueryTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Friendship
  alias K2pokerIo.Repo
  alias K2pokerIo.Queries.Friends.FriendsQuery

  import Ecto.Query

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Queries.Friends.FriendsQuery

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("MyFriend")
    player3 = Helpers.create_user("PendingThem")
    player4 = Helpers.create_user("NotFriends")
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: false}))
    %{player1: player1, player2: player2, player3: player3, player4: player4}
  end

  test "#find should return a friendship with given users", context do
    friendship = FriendsQuery.find(context.player1.id, context.player2.id)
    assert(friendship.status == true)
  end

  test "#find should return a friendship with given users (opposite call)", context do
    friendship = FriendsQuery.find(context.player2.id, context.player1.id)
    assert(friendship.status == true)
  end

  test "#find should return a pending them friendship with given users", context do
    friendship = FriendsQuery.find(context.player1.id, context.player3.id)
    assert(friendship.status == false)
  end

  test "#find should return a pending me friendship with given users", context do
    friendship = FriendsQuery.find(context.player3.id, context.player1.id)
    assert(friendship.status == false)
  end

  test "#find should not find a friendship that has not been created", context do
    friendship = FriendsQuery.find(context.player1.id, context.player4.id)
    refute(friendship)
  end

  test "#all should return all friends and pending friend requests", context do
    all_friends = FriendsQuery.all(context.player1.id)
    assert Enum.count(all_friends) == 2
  end

  test "#all decorated should return a list of decorated users", context do
    decorated = FriendsQuery.all(context.player1.id) |> FriendsQuery.decorate_users(context.player1.id)
    friend1 = List.first(decorated)
    friend2 = List.last(decorated)
    assert(Enum.count(decorated) == 2)
    assert(friend1.status == :friend)
    assert(friend2.status == :pending_them)
  end

  test "#friends_only should return all the users confirmed friends", context do
    friends_only = FriendsQuery.friends_only(context.player1.id)
    assert(Enum.count(friends_only) == 1)
    assert(List.first(friends_only).friend_id == context.player2.id)
  end

  test "#friends_only decorated should return a list of decorated users", context do
    decorated = FriendsQuery.friends_only(context.player1.id) |> FriendsQuery.decorate_users(context.player1.id)
    friend = List.first(decorated)
    assert(Enum.count(decorated) == 1)
    assert(friend.status == :friend)
  end

  test "#pending_me should return all the users I need to confirm friendships with", context do
    pending_friends = FriendsQuery.pending_me(context.player3.id)
    assert(Enum.count(pending_friends) == 1)
    assert(List.first(pending_friends).user_id == context.player1.id)
  end

  test "#pending_me decorated should return a list of decorated users", context do
    decorated = FriendsQuery.pending_me(context.player3.id) |> FriendsQuery.decorate_users(context.player3.id)
    friend = List.first(decorated)
    assert(Enum.count(decorated) == 1)
    assert(friend.status == :pending_me)
  end

  test "#pending_them should return all the users that need to confirm my friendship requests", context do
    pending_friends = FriendsQuery.pending_them(context.player1.id)
    assert(Enum.count(pending_friends) == 1)
    assert(List.first(pending_friends).friend_id == context.player3.id)
  end

  test "#pending_them decorated should return a list of decorated users", context do
    decorated = FriendsQuery.pending_them(context.player1.id) |> FriendsQuery.decorate_users(context.player1.id)
    friend = List.first(decorated)
    assert(Enum.count(decorated) == 1)
    assert(friend.status == :pending_them)
  end

  test "#ids should return the ids for all the users friends", context do
    friend_ids = FriendsQuery.ids(context.player1.id)
    assert Enum.count(friend_ids) == 1
    assert Enum.member?(friend_ids,context.player2.id)
    refute Enum.member?(friend_ids,context.player3.id)
  end

end
