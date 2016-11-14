defmodule K2pokerIo.Commands.Game.GetDataCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  import Ecto.Changeset

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
    Game.decode_game_data(game.data)
    |> Game.player_data(player_id)
  end

end
