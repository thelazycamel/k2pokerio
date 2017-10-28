defmodule K2pokerIo.Commands.Game.GetOpponentProfileCommand do

  alias K2pokerIo.User
  alias K2pokerIo.Decorators.UserProfileDecorator
  alias K2pokerIo.Decorators.AnonUserProfileDecorator
  alias K2pokerIo.Decorators.BotProfileDecorator

  @doc "gets the opponents profile, with a given game and current_player_id returns a decorator (map) of user, anon user or bot"

  def execute(game, current_player_id) do
    get_opponent_id_from_game(game, current_player_id)
    |> opponent_profile(current_player_id)
  end

  defp opponent_profile(opponent_player_id, current_player_id) do
    {type, opponent_id} = User.get_id(opponent_player_id)
    cond do
      type == :user  -> user_profile_decorator(current_player_id, opponent_id)
      type == :anon  -> anon_user_profile_decorator(opponent_player_id)
      type == :bot   -> bot_profile_decorator()
      true           -> %{}
    end
  end

  defp user_profile_decorator(current_player_id, opponent_id) do
    UserProfileDecorator.decorate(current_player_id, opponent_id)
  end

  defp anon_user_profile_decorator(opponent_player_id) do
    AnonUserProfileDecorator.decorate(opponent_player_id)
  end

  defp bot_profile_decorator() do
    BotProfileDecorator.decorate()
  end

  defp get_opponent_id_from_game(game, current_player_id) do
    cond do
      current_player_id == game.player1_id -> game.player2_id
      current_player_id == game.player2_id -> game.player1_id
      true -> nil
    end
  end

end
