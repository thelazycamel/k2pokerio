defmodule K2pokerIo.Commands.Game.FoldCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo

  import Ecto.Query

  @doc "sends fold to K2poker and updates the game"
  def execute(game_id, player_id) do
    utd = get_user_tournament_detail(game_id, player_id)
    game = game(game_id)
    if game && can_fold?(utd) do
      fold(game, player_id)
      |> update_game(game)
      :ok
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

  defp game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  defp fold(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.fold(player_id)
  end

  defp update_game(game_data, game) do
    encoded_game_data = Poison.encode!(game_data)
    updated_changeset = Game.changeset(game, %{data: encoded_game_data})
    Repo.update!(updated_changeset) |> Repo.preload(:tournament)
  end

end
