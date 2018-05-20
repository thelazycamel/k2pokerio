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
    player2 = Helpers.create_user("stu")
    player3 = Helpers.create_user("Fred")
    player4 = Helpers.create_user("StevePending")
    player5 = Helpers.create_user("MrGrumpyNotFriends")
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player4.id, friend_id: player1.id, status: false}))
    %{player1: player1, player2: player2, player3: player3, player4: player4, player5: player5}
  end

  test "#all should return all the users friends", context do
    query = FriendsQuery.all(context.player1.id)
    friend1_id = context.player2.id
    friend2_id = context.player3.id
    %{^friend1_id => friend1_username} = query
    %{^friend2_id => friend2_username} = query
    assert(Enum.count(query) == 2)
    assert(friend1_username == context.player2.username)
    assert(friend2_username == context.player3.username)
  end

  test "#ids should return the ids for all the users friends", context do
    query = FriendsQuery.ids(context.player1.id)
    assert Enum.count(query) == 2
    assert Enum.member?(query,context.player2.id)
    assert Enum.member?(query,context.player3.id)
    refute Enum.member?(query,context.player4.id)
    refute Enum.member?(query,context.player5.id)
  end

  test "#all_and_pending should return all friends and pending friend requests", context do
    pending_them = Helpers.create_user("pip")
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: context.player1.id, friend_id: pending_them.id, status: false}))
    query = FriendsQuery.all_and_pending(context.player1.id)
    pending_me = Enum.find(query, fn (e) -> e.username == "StevePending" end)
    pending_them = Enum.find(query, fn (e) -> e.username == "pip" end)
    friend = Enum.find(query, fn (e) -> e.username == "stu" end)
    assert Enum.count(query) == 4
    assert pending_me.status == "pending_me"
    assert pending_them.status == "pending_them"
    assert friend.status == "friend"
  end

end
