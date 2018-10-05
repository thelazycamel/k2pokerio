defmodule K2pokerIo.Commands.Game.DiscardCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game

  @doc "Sends discard to K2poker for the (given) players (given) card and updates the game"

  def execute(game_id, player_id, card_index) do
    if game = get_game(game_id) do
      discard(game, player_id, card_index) |> update_game(game, player_id)
    else
      :error
    end
  end

  #PRIVATE

  defp get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  defp discard(game, player_id, card_index) do
    Game.decode_game_data(game.data)
    |> K2poker.discard(player_id, card_index)
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
    timestamp = NaiveDateTime.utc_now
    if player1_id = game.player1_id, do: %{p1_timestamp: timestamp}, else: %{p2_timestamp: timestamp}
  end

end
