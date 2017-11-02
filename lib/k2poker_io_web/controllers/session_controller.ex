defmodule K2pokerIoWeb.SessionController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Repo
  alias K2pokerIoWeb.Helpers.Session

  def new(conn, _params) do
    if logged_in?(conn) do
      redirect conn, to: tournament_path(conn, :index)
    else
      render conn, "new.html"
    end
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params, Repo) do
      {:ok, user} ->
        conn
        |> put_session(:player_id, "user|#{user.id}")
        |> put_flash(:info, "Logged in")
        |> redirect(to: "/tournaments")
      :error ->
        conn
        |> put_flash(:info, "Wrong email or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:player_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: "/")
  end

end
