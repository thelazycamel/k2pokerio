defmodule K2pokerIo.Commands.Game.PlayCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  alias Ecto.Multi
  import Ecto.Query

  def execute(game_id, player_id) do
    Multi.new()
    |> Multi.run(:get_game, fn _repo, %{} -> get_game(game_id) end)
    |> Multi.run(:game_data, fn _repo, %{get_game: get_game} -> play(get_game, player_id) end)
    |> Multi.run(:updated_game, fn _repo, %{game_data: game_data, get_game: get_game} -> Repo.update(updated_changeset(game_data, get_game, player_id)) end)
    |> Repo.transaction
    |> case do
      {:ok, %{get_game: _, game_data: _, updated_game: updated_game}} -> {:ok, updated_game}
      {:error, _, _, _} -> :error
    end
  end

  defp get_game(game_id) do
    game = Repo.one(from g in Game,
      where: g.id == ^game_id,
      lock: "FOR UPDATE",
      preload: [:tournament]
    )
    {:ok, game}
  end

  defp play(game, player_id) do
    game_data = Game.decode_game_data(game.data) |> K2poker.play(player_id)
    {:ok, game_data}
  end

  defp updated_changeset(game_data, game, player_id) do
    encoded_game_data = Poison.encode!(game_data)
    changes = Map.merge(update_timestamp(game, game_data, player_id), %{data: encoded_game_data})
    Game.changeset(game, changes)
  end

  # Update the players timestamp, if both players have played the reset both timestamps,
  #
  defp update_timestamp(game, game_data, player_id) do
    next_turn = Enum.all?(game_data.players, fn (player) -> player.status == "new" end)
    timestamp = NaiveDateTime.utc_now
    cond do
      next_turn -> %{p1_timestamp: timestamp, p2_timestamp: timestamp}
      player_id == game.player1_id -> %{p1_timestamp: timestamp}
      player_id == game.player2_id -> %{p2_timestamp: timestamp}
      true -> %{}
    end
  end

end
