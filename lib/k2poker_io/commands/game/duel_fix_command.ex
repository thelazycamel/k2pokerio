defmodule K2pokerIo.Commands.Game.DuelFixCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  import Ecto.Query

  @doc "Fixes an issue where both plays can create a new game at the same time in a duel so becoming locked in waiting for other player"

  # this is all a bit of a hack, but fixes an issue where both games
  # in a duel are created at exactly the same time, a ping is sent
  # after a random number of seconds to check if two games are open
  # and will delete the users game they opened if so
  #

  def execute(utd) do
    cond do
      utd.tournament.tournament_type != "duel" -> :ok
      two_games_waiting(utd) -> fix_games(utd)
      true -> :ok
    end
  end

  def two_games_waiting(utd) do
    Enum.count(games_waiting_for_players_query(utd)) > 1
  end

  def games_waiting_for_players_query(utd) do
    query = from Game, where: [ tournament_id: ^utd.tournament_id, open: true ]
    Repo.all(query)
  end

  # destory the players own game, then the users game will be refreshed
  #
  def fix_games(utd) do
    query = from Game, where: [ tournament_id: ^utd.tournament_id, open: true, player1_id: ^utd.player_id]
    Repo.all(query)
    |> List.first
    |> Repo.delete!
    :updated
  end

end
