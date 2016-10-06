defmodule K2pokerIo.PageController do
  use K2pokerIo.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def test(conn, _params) do
    game = K2poker.new("stu", "bob")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
      |> K2poker.play("bob")
      |> K2poker.play("stu")
    render conn, "test.html", game: game
  end

end
