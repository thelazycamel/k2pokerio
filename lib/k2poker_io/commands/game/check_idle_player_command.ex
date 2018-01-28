defmodule K2pokerIo.Commands.Game.CheckIdlePlayerCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game
  alias K2pokerIo.Commands.Game.PlayCommand

  @doc "Checks if the opposing player is idle and force plays them if so"

  def execute(game_id, player_id) do
    check_opponents_timestamp(game_id, player_id)
  end

  #private

  defp check_opponents_timestamp(game_id, player_id) do
    game = Repo.get(Game, game_id)
    timestamp = opponents_timestamp(game, player_id)
    if timestamp do
      timestamp = convert_timestamp_to_timex(timestamp)
      fifteen_seconds_ago = Timex.now |> Timex.shift(seconds: -15)
      if Timex.before?(timestamp, fifteen_seconds_ago) do
        force_play(game, player_id)
      else
        {:ok, :no_change}
      end
    else
      {:ok, :no_change}
    end
  end

  defp force_play(game, player_id) do
    PlayCommand.execute(game.id, opponent_id(game, player_id))
    {:ok, :forced_play}
  end

  defp opponents_timestamp(game, player_id) do
    if player_id == game.player1_id do
      game.p2_timestamp
    else
      game.p1_timestamp
    end
  end

  def opponent_id(game, player_id) do
    if player_id == game.player1_id do
      game.player2_id
    else
      game.player1_id
    end
  end

  defp convert_timestamp_to_timex(ecto_time) do
    ecto_time
    |> Ecto.DateTime.dump
    |> elem(1)
    |> Timex.DateTime.Helpers.construct("Etc/UTC")
  end

end
