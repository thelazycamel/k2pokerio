defmodule K2pokerIo.GameController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.JoinCommand
  alias K2pokerIo.Commands.Game.GetOpponentProfileCommand

  def play(conn, _params) do
    if player_id = get_session(conn, :player_id) do
      if utd = get_user_tournament_detail(conn) do
        render(conn, "play.html", player_id: player_id, tournament_id: utd.tournament_id, logged_in: logged_in?(conn))
      else
        redirect(conn, to: "/tournaments")
      end
      redirect(conn, to: "/")
    end
  end

  def join(conn, _params) do
    if utd = get_user_tournament_detail(conn) do
      if user_already_in_a_game?(utd.game) do
        json conn, %{status: "ok", game_id: utd.game_id, joined: true}
      else
        case JoinCommand.execute(utd) do
          {:ok, game} -> json conn, %{status: "ok", game_id: game.id, joined: true}
          {:error} -> json conn, %{status: "error"}
        end
      end
    else
      json conn, %{status: "error"}
    end
  end

  def opponent_profile(conn, _params) do
    utd = get_user_tournament_detail(conn)
    opponent_profile = GetOpponentProfileCommand.execute(utd.game, utd.player_id)
    json conn, opponent_profile
  end

  #PRIVATE METHODS

  defp get_user_tournament_detail(conn) do
    utd_id = get_session(conn, :utd_id)
    utd = Repo.get(UserTournamentDetail, utd_id) |> Repo.preload(:game)
  end

  defp user_already_in_a_game?(game) do
    game && game.open
  end

end
