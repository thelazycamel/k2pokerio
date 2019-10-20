defmodule K2pokerIo.RegistrationControllerTest do

  use K2pokerIoWeb.ConnCase, async: false

  alias K2pokerIo.User
  alias K2pokerIo.Repo

  import Ecto.Query

  doctest K2pokerIoWeb.RegistrationController

  test "#new should render a user form", %{conn: conn} do
    response = conn
      |> get(Routes.registration_path(conn, :new))
      |> response(200)
    email_field = ~r/user_email/
    username_field = ~r/user_username/
    password_field = ~r/user_username/
    assert(response =~ email_field)
    assert(response =~ username_field)
    assert(response =~ password_field)
  end

  test "#new should create a new user", %{conn: conn} do
    params = %{"user" =>
      %{ "email" => "bob@test.com",
         "username" => "bob",
         "password" => "password"
       }
    }
    response = conn
      |> post(Routes.registration_path(conn, :create, params))
      |> response(302)
    expected = ~r/href="\/tournaments"/
    user = Repo.one(from u in User, where: [email: "bob@test.com"])
    assert(response =~ expected)
    assert(user)
    assert(user.image == "/images/profile-images/fish.png")
    assert(user.crypted_password)
  end
end
