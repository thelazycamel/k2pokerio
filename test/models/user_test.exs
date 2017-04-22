defmodule K2pokerIo.UserTest do
  use K2pokerIo.ModelCase

  alias K2pokerIo.User

  @valid_attrs %{password: "abc123", email: "bob@test.com", username: "bob"}
  @invalid_attrs %{password: "abc123", email: "wrong"}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
