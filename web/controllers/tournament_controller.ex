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

  def join(conn, %{"id" => id}) do
    case JoinCommand.execute(current_user(conn), id) do
      {:ok} -> redirect conn, to: game_path(conn, :play)
      {:error} -> redirect conn, to: page_path(conn, :index)
    end
  end

end
