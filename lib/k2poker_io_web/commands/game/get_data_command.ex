defmodule K2pokerIoWeb.Commands.Game.GetDataCommand do

  alias K2pokerIo.Game
  alias K2pokerIoWeb.Commands.Tournament.UpdateScoresCommand
  alias K2pokerIo.Repo
  import Ecto.Changeset

  @doc "gets the game data for the player (and checks if game is finished?)"

  def execute(game_id, player_id) do
    if game = get_game(game_id) do
      player_game_data(game, player_id)
    else
      :error
    end
  end

  def get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  def player_game_data(game, player_id) do
    player_data = Game.player_data(game, player_id)
    if player_data.status == "finished" do
      UpdateScoresCommand.execute(game)
    end
    player_data
  end

end
