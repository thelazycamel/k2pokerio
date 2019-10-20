defmodule K2pokerIo.PageControllerTest do

  use K2pokerIoWeb.ConnCase, async: false
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  alias K2pokerIo.Test.Helpers

  doctest K2pokerIoWeb.PageController

  setup do
    %{tournament: Helpers.create_tournament}
  end

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "anon_user_username"
    assert html_response(conn, 200) =~ "Sign Up"
  end

  test "#anon_user_create should create an anonymous user (utd)", %{conn: conn} do
    response = conn
      |> post(Routes.page_path(conn, :anon_user_create, %{"anon_user" => %{"username" => "bob"}}))
      |> response(302)
    utd = Repo.one(UserTournamentDetail)
    expected = ~r/href="\/games\/play"/
    player_id = ~r/anon\|bob/
    assert(String.match?(response, expected))
    assert(String.match?(utd.player_id, player_id))
    assert(utd.username == "bob")
  end

end
