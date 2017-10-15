defmodule K2pokerIoWeb.Commands.Game.RequestBotCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game

  def execute(game_id) do
    game = get_game(game_id)
    if no_opponent?(game) && tournament_allows_bots?(game) do
      set_bot_as_player_2(game)
    else
      {:error}
    end
  end

  defp get_game(game_id) do
    Repo.get(Game, game_id) |> Repo.preload(:tournament)
  end

  #TODO when setting up specific tournaments
  defp tournament_allows_bots?(game) do
    #check for game.tournament.bots
    %{game: game}
    true
  end

  defp no_opponent?(game) do
    is_nil(game.player2_id)
  end

  defp set_bot_as_player_2(game) do
    game_changeset = Game.join_changeset(game, %{player2_id: "BOT", waiting_for_players: false})
    case Repo.update(game_changeset) do
      {:ok, game} -> {:ok, game}
      {:error, _} -> {:error}
    end
  end

end
