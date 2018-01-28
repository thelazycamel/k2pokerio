defmodule K2pokerIo.Commands.Game.PlayCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game

  def execute(game_id, player_id) do
    if game = get_game(game_id) do
      play(game, player_id) |> update_game(game, player_id)
    else
      :error
    end
  end

  defp get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  defp play(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.play(player_id)
  end

  defp update_game(game_data, game, player_id) do
    encoded_game_data = Poison.encode!(game_data)
    changes = Map.merge(update_timestamp(game, player_id), %{data: encoded_game_data})
    updated_changeset = Game.changeset(game, changes)
    case Repo.update(updated_changeset) do
      {:ok, updated_game} -> {:ok, updated_game}
      {:error, _} -> :error
    end
  end

  defp update_timestamp(game, player_id) do
    timestamp = Ecto.DateTime.utc
    player1_id = game.player1_id
    player2_id = game.player2_id
    case player_id do
      player1_id -> %{p1_timestamp: timestamp}
      player2_id -> %{p2_timestamp: timestamp}
      _ -> %{}
    end
  end

end
