defmodule K2pokerIo.TournamentController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Tournament.JoinCommand

  # TODO the index will only be for logged in players
  # and should list all the current tournaments available
  # for the given user:
  # All Open tournaments, that are not finished and all
  # Private tournaments (where the users id is in the array of player_ids) that are not finished
  # Note to self, users should only be allowed to create private tournaments,
  # in the future an admin (manager) should be able to create open tournaments
  # in the backend.
  #
  def index(conn, _) do
    tournaments = Repo.all(Tournament)
    render(conn, "index.html", tournaments: tournaments)
  end

  # TODO once logged in users are created we need to check
  # if user has access to the tournament
  # To start with I will just be using the ONE tournament.
  #
  def show(conn, %{"id" => id}) do
    tournament = Repo.get!(Tournament, id)
    player_id = get_session(conn, :player_id)
    cond do
      player_id == nil ->
        redirect conn, to: page_path(conn, :index)
      true ->
      detail = Repo.get_by(UserTournamentDetail, player_id: player_id)
      render(conn, "show.html", player_id: player_id, tournament: tournament, username: detail.username, logged_in: logged_in?(conn), tournament_id: tournament.id)
    end
  end

  def join(conn, %{"id" => id}) do
    case JoinCommand.execute(current_user(conn), id) do
      {:ok} -> redirect conn, to: tournament_path(conn, :show, id)
      {:error} -> redirect conn, to: tournament_path(conn, :index) #with a flash message
    end
  end

end
