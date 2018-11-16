defmodule K2pokerIo.Decorators.UserProfileDecorator do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.UserStats
  alias K2pokerIo.Commands.User.GetFriendStatusCommand
  alias K2pokerIo.Decorators.UserStatsDecorator

  import Ecto.Query

  def decorate(current_player_id, opponent_id) do
    opponent = get_opponent(opponent_id)
    Map.merge(user_info(current_player_id, opponent), user_stats(opponent))
  end

  defp user_info(current_player_id, opponent) do
    %{
      id:       opponent.id,
      username: opponent.username,
      opponent: :user,
      blurb:    opponent.blurb,
      image:    opponent.image,
      friend:   friend_status(opponent.id, current_player_id),
      stats:    true
    }
  end

  defp user_stats(opponent) do
    UserStatsDecorator.decorate(opponent.user_stats)
  end

  defp friend_status(opponent_id, current_player_id) do
    {type, current_user_id} = User.get_id(current_player_id)
    if type == :user do
      GetFriendStatusCommand.execute(current_user_id, opponent_id)
    else
      :na
    end
  end

  defp get_opponent(opponent_id) do
    Repo.one(
      from u in User,
      where: u.id == ^opponent_id,
      preload: [:user_stats]
    )
  end

end
