defmodule K2pokerIo.Commands.Game.GetDataCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.EndGameCommand
  alias K2pokerIo.Repo

  import Ecto.Query

  @doc "gets the game data for the player (and checks if game is finished?)"

  def execute(game_id, player_id) do
    get_game(game_id)
    |> player_game_data(player_id)
  end

  defp get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  defp player_game_data(game, player_id) do
    if game do
      player_data = Game.player_data(game, player_id)
      cond do
        player_data.status == "finished" ->
          EndGameCommand.execute(game)
          |> merge_folded(player_id, player_data)
        true -> merge_folded(game, player_id, player_data)
      end
    else
      :error
    end
  end

  def merge_folded(game, player_id, player_data) do
    tournament_id = game.tournament.id
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player_id, tournament_id: ^tournament_id])
    Map.merge(player_data, %{fold: utd.fold})
  end
end

