defmodule K2pokerIo.GetFriendStatusCommandTest do

  use K2pokerIo.DataCase, async: false

  alias K2pokerIo.Commands.User.GetFriendStatusCommand
  alias K2pokerIo.Friendship
  alias K2pokerIo.Test.Helpers

  alias K2pokerIo.Repo

  setup do
    user1 = Helpers.create_user("stu")
    user2 = Helpers.create_user("bob")
    user3 = Helpers.create_user("fred")
    %{user1: user1, user2: user2, user3: user3}
  end

  test "it should return not friends", context do
    result = GetFriendStatusCommand.execute(context.user1.id, context.user2.id)
    assert(result == :not_friends)
  end

  test "it should return :pending_them if they have not confirmed", context do
    changeset = Friendship.changeset(%Friendship{}, %{user_id: context.user1.id, friend_id: context.user2.id, status: false})
    Repo.insert!(changeset)
    result = GetFriendStatusCommand.execute(context.user1.id, context.user2.id)
    assert(result == :pending_them)
  end

  test "it should return :pending_me if I have not confirmed", context do
    changeset = Friendship.changeset(%Friendship{}, %{user_id: context.user2.id, friend_id: context.user1.id, status: false})
    Repo.insert!(changeset)
    result = GetFriendStatusCommand.execute(context.user1.id, context.user2.id)
    assert(result == :pending_me)
  end

  test "it should return :friend if we have both confirmed", context do
    changeset = Friendship.changeset(%Friendship{}, %{user_id: context.user1.id, friend_id: context.user2.id, status: true})
    Repo.insert!(changeset)
    result = GetFriendStatusCommand.execute(context.user1.id, context.user2.id)
    assert(result == :friend)
  end

end
