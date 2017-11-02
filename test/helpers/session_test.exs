defmodule K2pokerIo.SessionTest do

  use K2pokerIoWeb.ConnCase

  alias K2pokerIoWeb.Helpers.Session
  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.Repo

  import Plug.Test

  doctest K2pokerIoWeb.Helpers.Session

  setup do
    changeset = User.changeset(%User{},
      %{
        username: "bob",
        email: "bob@test.com",
        password: "abc123"
      }
    )
    {:ok, user} = RegisterCommand.create(changeset)
    %{user: user}
  end

  test "login", context do
    params = %{"email" => "bob@test.com", "password" => "abc123"}
    {:ok, user} = Session.login(params, Repo)
    assert(user.id == context.user.id)
  end

  test "login fail" do
    params = %{"email" => "bob@test.com", "password" => "wrongPassword"}
    assert(:error = Session.login(params, Repo))
  end

  test "current_user", %{conn: conn, user: user} do
    conn = conn
      |> init_test_session(player_id: "user|#{user.id}")
    current_user = Session.current_user(conn)
    assert(current_user.id == user.id)
  end

  test "logged_in?", %{conn: conn, user: user} do
    conn = conn
      |> init_test_session(player_id: "user|#{user.id}")
    assert(Session.logged_in?(conn))
  end

end
