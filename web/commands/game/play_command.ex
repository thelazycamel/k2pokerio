defmodule K2pokerIo.Commands.Game.PlayCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  import Ecto.Changeset

  def execute(game_id, player_id) do
    if game = get_game(game_id) do
      play(game, player_id) |> update_game(game)
    else
      :error
    end
  end

  def get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  def play(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.play(player_id)
  end

  def update_game(game_data, game) do
    encoded_game_data = Poison.encode!(game_data)
    updated_changeset = Game.changeset(game, %{data: encoded_game_data})
    case Repo.update(updated_changeset) do
      {:ok, updated_game} -> {:ok, updated_game}
      {:error, _} -> :error
    end
  end

end
