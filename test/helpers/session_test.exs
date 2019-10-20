defmodule K2pokerIo.SessionTest do

  use K2pokerIoWeb.ConnCase, async: false

  alias K2pokerIoWeb.Helpers.Session
  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.RegisterCommand

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
    {:ok, user} = RegisterCommand.execute(changeset)
    %{user: user}
  end

  test "login", context do
    params = %{"email" => "bob@test.com", "password" => "abc123"}
    {:ok, user} = Session.login(params)
    assert(user.id == context.user.id)
  end

  test "login with username", context do
    params = %{"email" => "bob", "password" => "abc123"}
    {:ok, user} = Session.login(params)
    assert(user.id == context.user.id)
  end

  test "login fail" do
    params = %{"email" => "bob@test.com", "password" => "wrongPassword"}
    assert(:error = Session.login(params))
  end

  test "current_user", %{conn: conn, user: user} do
    conn = init_test_session(conn, player_id: User.player_id(user))
    current_user = Session.current_user(conn)
    assert(current_user.id == user.id)
  end

  test "logged_in?", %{conn: conn, user: user} do
    conn = conn
      |> init_test_session(player_id: "user|#{user.id}")
    assert(Session.logged_in?(conn))
  end

end
