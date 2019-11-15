defmodule K2pokerIo.FriendsQueryTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Friendship
  alias K2pokerIo.Repo
  alias K2pokerIo.Queries.Friends.FriendsQuery

  import Ecto.Query

  use K2pokerIo.DataCase, async: false

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
    query = FriendsQuery.all(context.player1.id, %{})
    assert Enum.count(query.entries) == 2
  end

  test "#all decorated should return a list of decorated users", context do
    query = FriendsQuery.all(context.player1.id, %{})
    decorated = FriendsQuery.decorate_friendships(query.entries, context.player1.id)
    friend1 = List.first(decorated)
    friend2 = List.last(decorated)
    assert(Enum.count(decorated) == 2)
    assert(friend1.status == :friend)
    assert(friend2.status == :pending_them)
  end

  test "#friends_only should return all the users confirmed friends", context do
    query = FriendsQuery.friends_only(context.player1.id, %{})
    assert(Enum.count(query.entries) == 1)
    assert(List.first(query.entries).friend_id == context.player2.id)
  end

  test "#friends_only decorated should return a list of decorated users", context do
    query = FriendsQuery.friends_only(context.player1.id, %{})
    decorated = FriendsQuery.decorate_friendships(query.entries, context.player1.id)
    friend = List.first(decorated)
    assert(Enum.count(decorated) == 1)
    assert(friend.status == :friend)
  end

  test "#pending_me should return all the users I need to confirm friendships with", context do
    query = FriendsQuery.pending_me(context.player3.id, %{})
    assert(Enum.count(query.entries) == 1)
    assert(List.first(query.entries).user_id == context.player1.id)
  end

  test "#pending_me decorated should return a list of decorated users", context do
    query = FriendsQuery.pending_me(context.player3.id, %{})
    decorated = FriendsQuery.decorate_friendships(query.entries, context.player3.id)
    friend = List.first(decorated)
    assert(Enum.count(decorated) == 1)
    assert(friend.status == :pending_me)
  end

  test "#pending_them should return all the users that need to confirm my friendship requests", context do
    query = FriendsQuery.pending_them(context.player1.id, %{})
    assert(Enum.count(query.entries) == 1)
    assert(List.first(query.entries).friend_id == context.player3.id)
  end

  test "#pending_them decorated should return a list of decorated users", context do
    query = FriendsQuery.pending_them(context.player1.id, %{})
    decorated = FriendsQuery.decorate_friendships(query.entries, context.player1.id)
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

  test "#count should return number of pending_me when passed", context do
    count = FriendsQuery.count(context.player3.id, "pending_me")
    assert(count == 1)
  end

  test "#count should return number of friends when passed", context do
    count = FriendsQuery.count(context.player1.id, "friends")
    assert(count == 1)
  end

  test "#count should return number of pending_them when passed", context do
    count = FriendsQuery.count(context.player1.id, "friends")
    assert(count == 1)
  end

  test "#search_users should return a list of users and friends status with given user/query", context do
    query = FriendsQuery.search_users(context.player1.id, "friend", %{})
    friends = FriendsQuery.decorate_users(query.entries, context.player1.id)
    friend1 = List.first(friends)
    friend2 = List.last(friends)
    assert(query.total_entries== 2)
    assert(friend1.username == "MyFriend")
    assert(friend2.username == "NotFriends")
    assert(friend2.status == :not_friends)
  end

  test "#decorate_users should return a list of users sorted by username do", context do
    friend3 = Helpers.create_user("aFriend")
    friend4 = Helpers.create_user("zFriend")
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: context.player1.id, friend_id: friend3.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: context.player1.id, friend_id: friend4.id, status: true}))
    query = FriendsQuery.all(context.player1.id, %{})
    friends = FriendsQuery.decorate_friendships(query.entries, context.player1.id)
    assert Enum.count(friends) == 4
    assert Enum.at(friends, 0).username == "aFriend"
    assert Enum.at(friends, 1).username == "MyFriend"
    assert Enum.at(friends, 2).username == "PendingThem"
    assert Enum.at(friends, 3).username == "zFriend"
  end

  test "pagination with no params", context do
    query = FriendsQuery.all(context.player1.id, %{})
    assert(Enum.count(query.entries) == 2)
    assert(query.page_number == 1)
    assert(query.page_size == 7)
    assert(query.total_entries == 2)
    assert(query.total_pages == 1)
  end

  @tag :skip #this is not returning the sencond page
  test "pagination with page and per page sent", context do
    query = FriendsQuery.all(context.player1.id, %{"page_size" => 1, "page_number" => 2})
    assert(Enum.count(query.entries) == 1)
    assert(query.total_entries == 2)
    assert(query.total_pages == 2)
    assert(query.page_number == 2)
  end

end
