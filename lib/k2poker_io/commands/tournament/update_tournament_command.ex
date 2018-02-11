defmodule K2pokerIo.Commands.Tournament.UpdateTournamentCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail

  import Ecto.Query

  @doc "checks if tournament is complete, players reached summit with given game"

  def execute(game, utd) do
    update_tournament(game, utd)
    game
  end

  defp get_utds(game) do
    tournament_id = game.tournament.id
    player1_id = game.player1_id
    player2_id = game.player2_id
    query = from utd in UserTournamentDetail,
      where: (utd.tournament_id == ^tournament_id and utd.player_id in [^player1_id, ^player2_id])
    utds = Repo.all(query)
  end

  defp update_tournament(game, utd) do
    tournament_type = game.tournament.type
    private = game.tournament.private
    default = game.tournament.default_tournament
    cond do
      tournament_type == "duel" ->
        close_tournament(game) |> alert_players(utd)
      tournament_type == "tournament" && private == true ->
        close_tournament(game) |> alert_players(utd)
      tournament_type == "tournament" && default == true ->
        message_room(game, utd) |> alert_player(utd)
      tournament_type == "tournament" && private == false ->
        close_tournament(game) |> alert_players(utd)
    end
  end

  defp close_tournament(game) do

  end

  defp alert_players(game, utds) do

  end

  defp alert_player(game, utds) do

  end

  defp message_room(game, utds) do

  end

end
