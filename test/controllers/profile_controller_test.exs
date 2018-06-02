defmodule K2pokerIo.ProfileControllerTest do

  use K2pokerIoWeb.ConnCase
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User

  import Plug.Test

  doctest K2pokerIoWeb.ProfileController

  setup do
    %{player: Helpers.create_user("stu")}
  end

  test "#edit", %{conn: conn, player: player} do
    conn = init_test_session(conn, player_id: User.player_id(player))
    conn = get(conn, "/profile")
    expected = ~r/body\ class.*profile\ edit/
    assert html_response(conn, 200) =~ expected
  end

  #TODO test update_blurb, update_image, update_password

end
