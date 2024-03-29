defmodule K2pokerIoWeb.GameController do

  use K2pokerIoWeb, :controller
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Game.JoinGameCommand
  alias K2pokerIo.Commands.Game.QuitGameCommand
  alias K2pokerIo.Commands.Game.GetOpponentProfileCommand
  alias K2pokerIo.Commands.Game.DuelFixCommand

  def play(conn, _params) do
    if player_id = get_session(conn, :player_id) do
      if utd = get_user_tournament_detail(conn) do
        render(conn, "play.html",
                player_id: player_id,
                tournament_id: utd.tournament_id,
                logged_in: logged_in?(conn),
                chat_disabled: User.chat_disabled?(current_user(conn)) || false,
                bots: utd.tournament.bots,
                max_score: utd.tournament.max_score,
                tournament_type: utd.tournament.tournament_type
        )
      else
        redirect(conn, to: "/tournaments")
      end
    else
      redirect(conn, to: "/")
    end
  end

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

  def quit(conn, _params) do
    if utd = get_user_tournament_detail(conn) do
      if QuitGameCommand.execute(utd) do
        json conn, %{ok: true}
      else
        json conn, %{error: 401}
      end
    else
      json conn, %{error: 401}
    end
  end

  def opponent_profile(conn, _params) do
    utd = get_user_tournament_detail(conn)
    opponent_profile = GetOpponentProfileCommand.execute(utd.game, utd.player_id)
    json conn, opponent_profile
  end

  def player_score(conn, _params) do
    utd = get_user_tournament_detail(conn)
    json conn, %{current_score: utd.current_score, username: utd.username}
  end

  def duel_fix(conn, _) do
    utd = get_user_tournament_detail(conn)
    result = DuelFixCommand.execute(utd)
    json conn, %{status: :ok, message: result}
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
