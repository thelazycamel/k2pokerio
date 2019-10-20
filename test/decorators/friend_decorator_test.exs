defmodule K2pokerIo.FriendDecoratorTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Decorators.FriendDecorator
  alias K2pokerIo.Friendship
  alias K2pokerIo.Repo

  import Ecto.Query

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Decorators.FriendDecorator

  setup do
    player1 = Helpers.create_user("Me")
    player2 = Helpers.create_user("MyFriend")
    player3 = Helpers.create_user("PendingThem")
    player4 = Helpers.create_user("NotFriends")
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: false}))
    %{ player1: player1, player2: player2, player3: player3, player4: player4}
  end

  test "It should return :friend for a user that has confirmed my request", context do
    user_id = context.player1.id
    friend_id = context.player2.id
    friend = Repo.one(from f in Friendship, where: f.user_id == ^user_id and f.friend_id == ^friend_id, preload: [:user, :friend])
    friend = FriendDecorator.decorate(friend, user_id)
    assert friend.status == :friend
  end

  test "It should return :friend when I have confirmed friends request", context do
    user_id = context.player2.id
    friend_id = context.player1.id
    friend = Repo.one(from f in Friendship, where: f.user_id == ^friend_id and f.friend_id == ^user_id, preload: [:user, :friend])
    friend = FriendDecorator.decorate(friend, user_id)
    assert friend.status == :friend
  end

  test "It should return :pending_them when they have not confirmed the request", context do
    user_id = context.player1.id
    friend_id = context.player3.id
    friend = Repo.one(from f in Friendship, where: f.user_id == ^user_id and f.friend_id == ^friend_id, preload: [:user, :friend])
    friend = FriendDecorator.decorate(friend, user_id)
    assert friend.status == :pending_them
  end

  test "It should return :pending_me when they have not confirmed the request", context do
    user_id = context.player3.id
    friend_id = context.player1.id
    friend = Repo.one(from f in Friendship, where: f.user_id == ^friend_id and f.friend_id == ^user_id, preload: [:user, :friend])
    friend = FriendDecorator.decorate(friend, user_id)
    assert friend.status == :pending_me
  end

  test "#status should return :not_friends when friendship does not exist", context do
    status = FriendDecorator.status(nil, context.player1.id)
    assert status == :not_friends
  end

end
