defmodule K2pokerIoWeb.SessionController do

  use K2pokerIoWeb, :controller

  alias K2pokerIoWeb.Helpers.Session

  def new(conn, _params) do
    if logged_in?(conn) do
      redirect conn, to: Routes.tournament_path(conn, :index)
    else
      render conn, "new.html"
    end
  end

  def create(conn, %{"session" => session_params}) do
    case Session.login(session_params) do
      {:ok, user} ->
        conn
        |> put_session(:player_id, "user|#{user.id}")
        |> put_flash(:info, "Welcome back #{user.username}")
        |> redirect(to: Routes.tournament_path(conn, :index))
      :error ->
        conn
        |> put_flash(:error, "Oops, seems like a wrong email/username or password")
        |> render("new.html")
    end
  end

  def delete(conn, _) do
    conn
    |> delete_session(:player_id)
    |> put_flash(:info, "Successfully Logged out")
    |> redirect(to: "/")
  end

end
