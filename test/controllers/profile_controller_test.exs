defmodule K2pokerIo.ProfileControllerTest do

  use K2pokerIoWeb.ConnCase
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User

  import Plug.Test

  doctest K2pokerIoWeb.ProfileController

  setup do
    %{player: Helpers.create_user("stu")}
  end

  test "#show", %{conn: conn, player: player} do
    conn = get(conn, profile_path(conn, :show, player.id))
    expected = ~r/body\ class.*profile\ show/
    assert html_response(conn, 200) =~ expected
  end

  test "#edit", %{conn: conn, player: player} do
    conn = init_test_session(conn, player_id: User.player_id(player))
    conn = get(conn, profile_path(conn, :edit))
    expected = ~r/body\ class.*profile\ edit/
    assert html_response(conn, 200) =~ expected
  end

  test "#update", %{conn: conn, player: player} do
    conn = init_test_session(conn, player_id: User.player_id(player))
    params = %{"profile" => %{"image" => "bob.png", blurb: "Hola Tester"}}
    response = conn
     |> patch(profile_path(conn, :update, player.id, params))
     |> response(302)
    expected = ~r/href.*\/profile/
    player = Repo.one(User, id: player.id)
    assert response =~ expected
    assert(player.image == "bob.png")
    assert(player.blurb == "Hola Tester")
  end

end
