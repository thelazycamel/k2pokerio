defmodule K2pokerIo.SessionTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Session
  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.Repo

  doctest K2pokerIo.Session

  setup do
    params = %{username: "bob", email: "bob@test.com", password: "password"}
    changeset = User.changeset(%User{}, params)
    {:ok, user} = RegisterCommand.create(changeset)
    %{user: user}
  end

  test "login", context do
    params = %{"email" => "bob@test.com", "password" => "password"}
    {:ok, user} = Session.login(params, Repo)
    assert(user.id == context.user.id)
  end

  #TODO current_user

end
