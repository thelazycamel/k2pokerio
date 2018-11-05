defmodule K2pokerIo.SessionControllerTest do

  use K2pokerIoWeb.ConnCase
  alias K2pokerIo.Commands.User.RegisterCommand
  alias K2pokerIo.User
  import Plug.Test

  doctest K2pokerIoWeb.SessionController

  setup do
    changeset = User.changeset(%User{},
      %{
        username: "stu",
        email: "stu@test.com",
        password: "password"
      }
    )
    {:ok, user} = RegisterCommand.execute(changeset)
    %{user: user}
  end

  test "#new session should render login page", %{conn: conn} do
    response = conn
      |> get(session_path(conn, :new))
      |> response(200)
    login = ~r/Login/
    email_field = ~r/session_email/
    password_field = ~r/session_password/
    assert(response =~ login)
    assert(response =~ email_field)
    assert(response =~ password_field)
  end

  test "#new session when logged in should redirect to tournament index", %{conn: conn, user: user} do
    conn = init_test_session(conn, player_id: User.player_id(user))
    response = conn
      |> get(session_path(conn, :new))
      |> response(302)
    expected = ~r/href="\/tournaments"/
    assert(response =~ expected)
  end

  test "#create should create a new session", %{conn: conn, user: user} do
    session_params = %{"session" => %{"email" => user.email, "password" => user.password}}
    response = conn
      |> post(session_path(conn, :create, session_params))
      |> response(302)
    expected = ~r/href="\/tournaments"/
    #TODO would be good to check get_session(:player_id) here, investigate!
    assert(response =~ expected)
  end

  test "#create should render error if incorrect params", %{conn: conn, user: user} do
    session_params = %{"session" => %{"email" => user.email, "password" => "hacker"}}
    response = conn
      |> post(session_path(conn, :create, session_params))
      |> response(200)
    expected = ~r/wrong\ email\/username\ or\ password/
    assert(response =~ expected)
  end

end
