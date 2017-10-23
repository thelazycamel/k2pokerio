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
    assert(User.player_id(user) == "user-#{user.id}")
  end

end
