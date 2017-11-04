defmodule K2pokerIoWeb.PageController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Commands.User.CreateAnonUser

  def index(conn, _params) do
    if logged_in?(conn) do
      redirect conn, to: tournament_path(conn, :index)
    else
      render conn, "index.html"
    end
  end

  def anon_user_create(conn, %{"anon_user" => %{"username" => anon_username}}) do
    case CreateAnonUser.execute(anon_username) do
      {:ok, utd} ->
        conn = put_session(conn, :player_id, utd.player_id)
        |> put_session(:utd_id, utd.id)
        redirect conn, to: game_path(conn, :play)
      {:error, _} ->
        redirect conn, to: page_path(conn, :index)
    end
  end

end
