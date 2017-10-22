defmodule K2pokerIo.Commands.Badges.UpdateGameBadgesCommand do

  alias K2pokerIo.Game

  def execute(game, player_id) do
    #TODO
    player_data = get_player_data(game, player_id)
    [game, player_id, player_data]
    game
  end

  defp get_player_data(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.player_data(player_id)
  end

end
