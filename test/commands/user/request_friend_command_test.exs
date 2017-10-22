defmodule K2pokerIo.RequestFriendCommandTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Test.Helpers

  setup do
    user1 = Helpers.create_user("stu")
    user2 = Helpers.create_user("bob")
    user3 = Helpers.create_user("fred")
    %{user1: user1, user2: user2, user3: user3}
  end

  test "it should create a new friend request", context do
    result = RequestFriendCommand.execute(context.user1.id, context.user2.id)
    assert(result == :pending_them)
    friendship = K2pokerIo.Repo.get_by(K2pokerIo.Friendship, user_id: context.user1.id)
    assert(friendship.status == false)
  end

  test "is should confirm pending them if requested twice", context do
    RequestFriendCommand.execute(context.user1.id, context.user2.id)
    result = RequestFriendCommand.execute(context.user1.id, context.user2.id)
    assert(result == :pending_them)
  end

  test "it should confirm players as friends", context do
    RequestFriendCommand.execute(context.user1.id, context.user2.id)
    result = RequestFriendCommand.execute(context.user2.id, context.user1.id)
    assert(result == :friend)
    friendship = K2pokerIo.Repo.get_by(K2pokerIo.Friendship, user_id: context.user1.id)
    assert(friendship.status == true)
  end

end


