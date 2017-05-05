defmodule K2pokerIo.PageController do
  use K2pokerIo.Web, :controller

  alias K2pokerIo.UserTournamentDetail

  def index(conn, _params) do
    if logged_in?(conn) do
      redirect conn, to: tournament_path(conn, :index)
    else
      render conn, "index.html"
    end
  end

  def anon_user_create(conn, %{"anon_user" => %{"username" => anon_username}}) do
    case K2pokerIo.AnonUser.create(conn, anon_username, default_tournament) do
      {:ok, utd} ->
        conn = put_session(conn, :player_id, utd.player_id)
        redirect conn, to: game_path(conn, :play)
      {:error, _} ->
        redirect conn, to: page_path(conn, :index)
    end
  end

  defp default_tournament do
    default_tournament = Repo.get_by(K2pokerIo.Tournament, default: true)
  end

end
