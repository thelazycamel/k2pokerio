require IEx
defmodule K2pokerIo.GameController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.Game

  def index(conn, _params) do
    games = Repo.all(Game)
    render conn, "index.html", games: games
  end

  # TODO: The game decodes, but can not handle the nested array of players so need to re-encode
  # NOTE: This is all just a hack anyway we would not be passing back the entire game object,
  # just selected data based on the current user
  #
  def show(conn, %{"id" => id}) do
    game =  Repo.get!(Game, id)
    game_data = Game.decode_game_data(game.data)
    render(conn, "show.html", game: game_data)
  end

  def new(conn, _params) do
    changeset = Game.changeset(%Game{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"game" => game_params}) do
    changeset = Game.create_new_changeset(%Game{}, game_params)

    case Repo.insert(changeset) do
      {:ok, game} ->
        conn
        |> put_flash(:info, "Game created successfully.")
        |> redirect(to: game_path(conn, :show, game.id))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end


end
