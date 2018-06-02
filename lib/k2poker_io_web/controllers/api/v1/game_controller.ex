defmodule K2pokerIoWeb.Api.V1.GameController do

  use K2pokerIoWeb, :controller
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.JoinGameCommand
  alias K2pokerIo.Commands.Game.GetOpponentProfileCommand

  #currently not working complaining about sessions, to be reviewed

  def join(conn, _params) do
    if utd = get_user_tournament_detail(conn) do
      if user_already_in_a_game?(utd.game) do
        json conn, %{status: "ok", game_id: utd.game_id, joined: true}
      else
        case JoinGameCommand.execute(utd) do
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

  #currently unused
  def player_score(conn, _params) do
    utd = get_user_tournament_detail(conn)
    json conn, %{current_score: utd.current_score, username: utd.username}
  end

  #PRIVATE METHODS

  defp get_user_tournament_detail(conn) do
    if utd_id = get_session(conn, :utd_id) do
      Repo.get(UserTournamentDetail, utd_id) |> Repo.preload([:game, :tournament])
    else
      nil
    end
  end

  defp user_already_in_a_game?(game) do
    game && game.open
  end

end
