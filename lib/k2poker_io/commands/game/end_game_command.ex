defmodule K2pokerIo.Commands.Game.EndGameCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game
  alias K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand
  alias K2pokerIo.Commands.Badges.UpdateGameBadgesCommand
  alias K2pokerIo.Commands.UserStats.UpdateGameStatsCommand

  @doc "runs over each player in the game and performs end game functions, update_scores and badges, checks tournament win/lose"

  def execute(game) do
    if game.open do
      update_player(game, game.player1_id)
      |> update_player(game.player2_id)
      |> mark_game_as_closed()
    else
      game
    end
  end

  defp update_player(game, player_id) do
    unless player_id == "BOT" do
      update_score(game, player_id)
      |> update_badges(player_id)
      |> update_user_stats(player_id)
    end
    game
  end

  defp update_score(game, player_id) do
    UpdatePlayerScoreCommand.execute(game, player_id)
  end

  defp update_badges(game, player_id) do
    UpdateGameBadgesCommand.execute(game, player_id)
  end

  defp update_user_stats(game, player_id) do
    UpdateGameStatsCommand.execute(game, player_id)
  end

  defp mark_game_as_closed(game) do
    changeset = Game.changeset(game, %{open: false})
    Repo.update!(changeset) |> Repo.preload(:tournament)
  end

end
