defmodule K2pokerIo.Commands.Game.EndGameCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game
  alias K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand
  alias K2pokerIo.Commands.Badges.UpdateGameBadgesCommand

  @doc "runs over each player in the game and performs end game functions, update_scores and badges, checks tournament win/lose"

  def execute(game) do
    if game.open do
      update_each_player(game)
      |> mark_game_as_closed()
    end
  end

  defp update_each_player(game) do
    Enum.each [game.player1_id, game.player2_id], fn (player_id) ->
      update_player(game, player_id)
    end
    game
  end

  defp update_player(game, player_id) do
    unless player_id == "BOT" do
      update_score(game, player_id)
      |> update_badges(player_id)
    end
  end

  defp update_score(game, player_id) do
    UpdatePlayerScoreCommand.execute(game, player_id)
  end

  defp update_badges(game, player_id) do
    UpdateGameBadgesCommand.execute(game, player_id)
  end

  defp mark_game_as_closed(game) do
    changeset = Game.changeset(game, %{open: false})
    {:ok, game} = Repo.update(changeset)
    game
  end


end
