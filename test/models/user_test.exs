defmodule K2pokerIo.UserTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.User
  alias K2pokerIo.Test.Helpers

  @valid_attrs %{password: "abc123", email: "bob@test.com", username: "bob"}
  @invalid_attrs %{password: "abc123", email: "wrong"}

  doctest K2pokerIo.User

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end

  test "#player_id" do
    user = Helpers.create_user("stu")
    assert(User.player_id(user) == "user|#{user.id}")
  end

  test "#get_id for a user should return a user type and user id" do
    player_id = "user|123"
    {type, user_id} = User.get_id(player_id)
    assert(type == :user)
    assert(user_id == 123)
  end

  test "#get_id for an anon-user should return a user type, but not an id" do
    player_id = "anon|1234"
    {type, user_id} = User.get_id(player_id)
    assert(type == :anon)
    assert(user_id == nil)
  end

  test "#get_id for a Bot should return a user type and user id" do
    player_id = "BOT"
    {type, user_id} = User.get_id(player_id)
    assert(type == :bot)
    assert(user_id == nil)
  end

end
