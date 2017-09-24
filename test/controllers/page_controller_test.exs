defmodule K2pokerIo.PageControllerTest do
  use K2pokerIoWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "anon_user_username"
    assert html_response(conn, 200) =~ "Sign Up"
  end
end
