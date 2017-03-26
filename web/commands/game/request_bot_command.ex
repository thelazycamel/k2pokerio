defmodule K2pokerIo.Commands.Game.RequestBotCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Repo
  import Ecto.Changeset

  def execute(game_id) do
    game = get_game(game_id)
    if opponent_exists?(game) do
      {:error, "opponent_exists"}
    else
      set_bot_as_player_2(game)
    end
  end

  defp get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  defp opponent_exists?(game) do
    !is_nil(game.player2_id)
  end

  defp set_bot_as_player_2(game) do
    game_changeset = Game.join_changeset(game, %{player2_id: "BOT", waiting_for_players: false})
    case Repo.update(game_changeset) do
      {:ok, game} -> {:ok, game}
      {:error, _} -> {:error, "opponent_exists"}
    end
  end

end
