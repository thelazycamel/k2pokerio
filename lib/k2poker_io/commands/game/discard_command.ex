defmodule K2pokerIo.Commands.Game.DiscardCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  alias Ecto.Multi
  import Ecto.Query

  @doc "Sends discard to K2poker for the (given) players (given) card and updates the game"

  def execute(game_id, player_id, card_index) do
    Multi.new()
    |> Multi.run(:get_game, fn %{} ->
      {:ok, Repo.one(
        from g in Game,
          where: g.id == ^game_id,
          lock: "FOR UPDATE",
          preload: [:tournament]) }
      end)
    |> Multi.run(:game_data, fn %{get_game: get_game} -> discard(get_game, player_id, card_index) end)
    |> Multi.run(:updated_game, fn %{get_game: get_game, game_data: game_data} -> Repo.update(updated_changeset(game_data, get_game, player_id)) end)
    |> Repo.transaction
    |> case do
      {:ok, %{get_game: _, game_data: _, updated_game: updated_game}} -> {:ok, updated_game}
      {:error, _, _, _} -> :error
    end
  end

  #PRIVATE

  defp discard(game, player_id, card_index) do
    game_data = Game.decode_game_data(game.data)
    |> K2poker.discard(player_id, card_index)
    {:ok, game_data}
  end

  defp updated_changeset(game_data, game, player_id) do
    encoded_game_data = Poison.encode!(game_data)
    changes = Map.merge(update_timestamp(game, player_id), %{data: encoded_game_data})
    Game.changeset(game, changes)
  end

  defp update_timestamp(game, player_id) do
    timestamp = NaiveDateTime.utc_now
    if player_id == game.player1_id, do: %{p1_timestamp: timestamp}, else: %{p2_timestamp: timestamp}
  end

end
