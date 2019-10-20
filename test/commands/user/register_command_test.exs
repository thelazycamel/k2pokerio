defmodule K2pokerIo.RegisterCommandTest do

  use K2pokerIo.DataCase, async: false

  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.User

  doctest K2pokerIo.Commands.User.RegisterCommand

  test "it should create a user" do
    params = %{username: "bob", email: "bob@test.com", password: "password"}
    changeset = User.changeset(%User{}, params)
    {:ok, user} = RegisterCommand.execute(changeset)
    assert(user.email == "bob@test.com")
    refute(user.crypted_password == "password")
  end

end
