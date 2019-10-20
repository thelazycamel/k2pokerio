defmodule K2pokerIo.Commands.Game.FoldCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  alias Ecto.Multi

  import Ecto.Query

  @doc "sends fold to K2poker and updates the game"
  def execute(game_id, player_id) do
    utd = get_user_tournament_detail(game_id, player_id)
    if can_fold?(utd) do
      do_fold_action(game_id, player_id)
    else
      :error
    end
  end

  defp can_fold?(utd) do
    utd && utd.fold
  end

  defp get_user_tournament_detail(game_id, player_id) do
    query = from UserTournamentDetail,
      where: [game_id: ^game_id, player_id: ^player_id]
    Repo.one(query)
  end

  defp do_fold_action(game_id, player_id) do
    Multi.new()
    |> Multi.run(:get_game, fn _repo, %{} -> get_game(game_id) end)
    |> Multi.run(:game_data, fn _repo, %{get_game: get_game} -> fold(get_game, player_id) end)
    |> Multi.run(:updated_game, fn repo, %{get_game: get_game, game_data: game_data} ->
      Repo.update(update_game_changeset(get_game, game_data))
    end)
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

  defp fold(game, player_id) do
    game_data = Game.decode_game_data(game.data)
    |> K2poker.fold(player_id)
    {:ok, game_data}
  end

  defp update_game_changeset(game, game_data) do
    Game.changeset(game, %{data: Poison.encode!(game_data)})
  end

end
