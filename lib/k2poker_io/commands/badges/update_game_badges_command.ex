defmodule K2pokerIo.Commands.Badges.UpdateGameBadgesCommand do

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail

  def execute(game, player_id) do
    unless UserTournamentDetail.is_anon_user?(player_id) do
      player_data = get_player_data(game, player_id)
      [game, player_id, player_data]
    end
    game
  end

  defp get_player_data(game, player_id) do
    Game.decode_game_data(game.data)
    |> K2poker.player_data(player_id)
  end

end
