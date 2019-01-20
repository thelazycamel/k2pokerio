defmodule K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Chat.BroadcastTournamentMessageCommand
  alias K2pokerIo.Commands.UserStats.UpdateTournamentStatsCommand
  alias K2pokerIo.Commands.Badges.UpdateTournamentBadgesCommand

  import Ecto.Query

  @doc "called when players score >= tournament max score and alerts/messages appropriate users depending on tournament type"

  def execute(game, utd) do
    update_tournament(game, utd)
    update_tournament_stats(utd)
    update_tournament_badges(utd)
  end

  defp update_tournament(game, utd) do
    tournament_type = game.tournament.tournament_type
    private = game.tournament.private
    default = game.tournament.default_tournament
    cond do
      tournament_type == "duel" ->
        close_tournament(game)
        |> message_room(utd)
        |> alert_all_losers(utd)
        |> alert_winner(utd)
      tournament_type == "tournament" && default == true ->
        message_room(game, utd)
        |> alert_winner(utd)
      tournament_type == "tournament" && private == true ->
        close_tournament(game)
        |> message_room(utd)
        |> alert_all_losers(utd)
        |> alert_winner(utd)
      tournament_type == "tournament" && private == false ->
        close_tournament(game)
        |> message_room(utd)
        |> alert_all_losers(utd)
        |> alert_winner(utd)
    end
  end

  defp update_tournament_stats(utd) do
    UpdateTournamentStatsCommand.execute(utd)
  end

  defp update_tournament_badges(utd) do
    UpdateTournamentBadgesCommand.execute(utd.tournament, utd.player_id)
  end

  defp close_tournament(game) do
    changeset = Tournament.changeset(game.tournament, %{finished: true})
    Repo.update(changeset)
    game
  end

  defp message_room(game, utd) do
    tournament = game.tournament
    message = "#{utd.username} has reached the Jackpot: #{tournament.max_score} ***"
    BroadcastTournamentMessageCommand.execute(tournament.id, message, utd.username)
    game
  end

  defp alert_all_losers(game, utd) do
    K2pokerIoWeb.Endpoint.broadcast!("tournament:#{game.tournament_id}", "tournament:loser", %{username: utd.username, player_id: utd.player_id, type: utd.tournament.tournament_type})
    game
  end

  defp alert_winner(game, utd) do
    K2pokerIoWeb.Endpoint.broadcast!("tournament:#{game.tournament_id}", "tournament:winner", %{username: utd.username, player_id: utd.player_id, type: utd.tournament.tournament_type})
    game
  end

end
