defmodule K2pokerIo.DestroyFriendshipCommandTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Commands.User.DestroyFriendshipCommand
  alias K2pokerIo.Friendship
  alias K2pokerIo.Test.Helpers

  alias K2pokerIo.Repo
  import Ecto.Query

  doctest K2pokerIo.Commands.User.DestroyFriendshipCommand

  setup do
    user1 = Helpers.create_user("stu")
    user2 = Helpers.create_user("bob")
    user3 = Helpers.create_user("fred")
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: user1.id, friend_id: user2.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: user3.id, friend_id: user1.id, status: true}))
    %{user1: user1, user2: user2, user3: user3}
  end

  test "it should destroy friendship I created", context do
    user1_id = context.user1.id
    user2_id = context.user2.id
    query = from f in Friendship,
      where: [user_id: ^user1_id, friend_id: ^user2_id],
      or_where: [user_id: ^user2_id, friend_id: ^user1_id],
      limit: 1
    friendship = Repo.one(query)
    assert(friendship.status == true)
    status = DestroyFriendshipCommand.execute(user1_id, user2_id)
    heartbreak = Repo.all(query)
    assert(Enum.count(heartbreak) == 0)
    assert(status == :not_friends)
  end

  test "it should destroy friendship they created", context do
    user1_id = context.user1.id
    user3_id = context.user3.id
    query = from f in Friendship,
      where: [user_id: ^user1_id, friend_id: ^user3_id],
      or_where: [user_id: ^user3_id, friend_id: ^user1_id],
      limit: 1
    friendship = Repo.one(query)
    assert(friendship.status == true)
    status = DestroyFriendshipCommand.execute(user1_id, user3_id)
    heartbreak = Repo.all(query)
    assert(Enum.count(heartbreak) == 0)
    assert(status == :not_friends)
  end

  test "it should not fail if users are not friends", context do
    user2_id = context.user2.id
    user3_id = context.user3.id
    status = DestroyFriendshipCommand.execute(user2_id, user3_id)
    assert(status == :not_friends)
  end

end
