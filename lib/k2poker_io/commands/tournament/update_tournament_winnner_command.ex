defmodule K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Chat.BroadcastTournamentMessageCommand

  import Ecto.Query

  @doc "called when players score >= tournament max score and alerts/messages appropriate users depending on tournament type"

  def execute(game, utd) do
    update_tournament(game, utd)
    game
  end

  defp update_tournament(game, utd) do
    tournament_type = game.tournament.type
    private = game.tournament.private
    default = game.tournament.default_tournament
    cond do
      tournament_type == "duel" ->
        close_tournament(game) |> alert_all_players(utd)
      tournament_type == "tournament" && default == true ->
        message_room(game, utd) |> alert_player(utd)
      tournament_type == "tournament" && private == true ->
        close_tournament(game) |> message_room(utd) |> alert_all_players(utd)
      tournament_type == "tournament" && private == false ->
        close_tournament(game) |> message_room(utd) |> alert_all_players(utd)
    end
  end

  defp close_tournament(game) do
    changeset = Tournament.changeset(game.tournament, %{finished: true})
    Repo.update(changeset)
    game
  end

  defp alert_all_players(game, utds) do
    #TODO trigger a pop-up message to all players in tournament "GAME OVER"
    game
  end

  defp alert_player(game, utds) do
    #TODO trigger a pop-up message to the user "CONGRATULATIONS YOU WON"
    game
  end

  defp message_room(game, utd) do
    tournament = game.tournament
    message = "has reached the Jackpot: #{tournament.max_score} ***"
    BroadcastTournamentMessageCommand.execute(tournament.id, message, utd.username)
    game
  end

end
