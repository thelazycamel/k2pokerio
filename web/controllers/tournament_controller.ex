require IEx
defmodule K2pokerIo.TournamentController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.Tournament

  # TODO the index will only be for logged in players
  # and should list all the current tournaments available
  # for the given user:
  # All Open tournaments, that are not finished and all
  # Private tournaments (where the users id is in the array of player_ids) that are not finished
  # Note to self, users should only be allowed to create private tournaments,
  # in the future an admin (manager) should be able to create open tournaments
  # in the backend.
  #
  def index(conn, params) do
    tournaments = Repo.all(Tournament)
    render(conn, "index.html", tournaments: tournaments)
  end

  # TODO once logged in users are created we need to check
  # if user has access to the tournament
  # To start with I will just be using the ONE tournament.
  #
  def show(conn, %{"id" => id}) do
    tournament = Repo.get!(Tournament, id)
    player_id = get_session(conn, :anon_user_id)
    username = conn.cookies["username"]
    render(conn, "show.html", tournament: tournament, player_id: player_id, username: username)
  end

end
