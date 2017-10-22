defmodule K2pokerIoWeb.TournamentController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Queries.Friends.FriendsQuery
  alias K2pokerIo.Queries.Tournaments.GetTournamentsForUserQuery
  alias K2pokerIo.Commands.Tournament.CreateCommand
  alias K2pokerIo.Commands.Tournament.JoinCommand
  alias K2pokerIo.Commands.Tournament.DestroyCommand

  def index(conn, _) do
    if logged_in?(conn) do
      render(conn, "index.html")
    else
      redirect conn, to: "/"
    end
  end

  def for_user(conn, _) do
    if logged_in?(conn) do
      tournaments = GetTournamentsForUserQuery.for_user(current_user(conn).id)
      json conn, tournaments
    else
      json conn, %{error: true}
    end
  end

  def join(conn, %{"id" => id}) do
    case JoinCommand.execute(current_user(conn), id) do
      {:ok, utd_id: utd_id} ->
        conn = put_session(conn, :utd_id, utd_id)
        redirect conn, to: game_path(conn, :play)
      {:error} -> redirect conn, to: page_path(conn, :index)
    end
  end

  def new(conn, _) do
    if logged_in?(conn) do
      friends = FriendsQuery.all(current_user(conn).id)
      render conn, "new.html", friends: friends
    else
      redirect conn, to: "/"
    end
  end

  def create(conn, %{"tournament" => tournament_params}) do
    CreateCommand.execute(current_user(conn), tournament_params)
    redirect conn, to: tournament_path(conn, :index)
  end

  def delete(conn, %{"id" => id}) do
    id = String.to_integer(id)
    DestroyCommand.execute(current_user(conn), id)
    json conn, %{tournament_id: id}
  end

end
