defmodule K2pokerIo.PlayGameCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  import Ecto.Changeset

  def execute(game_id, player_id) do
    game = get_game(game_id)
    game_data = play(game, player_id)
    case update_game(game, game_data) do
      {:ok, updated_game} -> Game.player_data(updated_game, player_id)
      :error -> Game.player_data(game, player_id)
    end
  end

  defp get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  defp play(game, player_id) do
    game_data = Game.decode_game_data(game.data)
    K2poker.play(game_data, player_id)
  end

  defp update_game(game, game_data) do
    encoded_game_data = Poison.encode!(game_data)
    updated_changeset = Game.changeset(game, %{})
    |> put_change(:data, encoded_game_data)
    case Repo.update(updated_changeset) do
      {:ok, updated_game} -> updated_game
      true -> :error
    end
  end

end
