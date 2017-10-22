defmodule K2pokerIo.FriendshipTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Friendship
  alias K2pokerIo.Test.Helpers

  setup do
    user1 = Helpers.create_user("stu")
    user2 = Helpers.create_user("bob")
    %{user1: user1, user2: user2}
  end

  test "changeset should validate user_id", context do
    params = %{user_id: nil, friend_id: context.user2.id, status: true}
    changeset = Friendship.changeset(%Friendship{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:user_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "changeset should validate friend_id", context do
    params = %{user_id: context.user1.id, friend_id: nil, status: false}
    changeset = Friendship.changeset(%Friendship{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:friend_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "changeset should validate status", context do
    params = %{user_id: context.user1.id, friend_id: nil, status: nil}
    changeset = Friendship.changeset(%Friendship{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:status]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end


end
