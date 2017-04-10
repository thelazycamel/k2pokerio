defmodule K2pokerIo.GameController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.JoinCommand

  #TODO just create a game "play" method
  # tnen we can simply land on the game play route and it will
  # join or wait for the next game, if you are part of a game
  # within the utd then you should be given that game, otherwise
  # join and find a new one

  def join(conn, _params) do
    #TODO move this check to see if they are already in a game to the join command
    if user_tournament_detail = get_user_tournament_detail(get_session(conn, :player_id)) do
      if user_already_in_a_game?(user_tournament_detail.game) do
        json conn, %{status: "ok", game_id: user_tournament_detail.game_id}
      else
        case JoinCommand.execute(user_tournament_detail) do
          {:ok, game} -> json conn, %{status: "ok", game_id: game.id}
          {:error} -> json conn, %{status: "error"}
        end
      end
    else
      json conn, %{status: "error"}
    end
  end

  def show(conn, %{"id" => id}) do
    game =  Repo.get!(Game, id)
    player_id = get_session(conn, :player_id)
    if Enum.member?([game.player1_id, game.player2_id], player_id) do
      render(conn, "show.html", game_id: id, tournament_id: game.tournament_id, player_id: player_id)
    else
      conn
      |> put_flash(:info, "Video deleted successfully.")
      |> redirect(to: tournament_path(conn, :index))
    end
  end

  defp get_user_tournament_detail(player_id) do
    Repo.get_by(UserTournamentDetail, player_id: player_id) |> Repo.preload(:game)
  end

  defp user_already_in_a_game?(game) do
    game && game.open
  end

end
