defmodule K2pokerIo.Decorators.UserProfileDecorator do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.GetFriendStatusCommand

  import Ecto.Query

  def decorate(current_player_id, opponent_id) do
    opponent = get_opponent(opponent_id)
    %{
      id:       opponent.id,
      username: opponent.username,
      opponent: :user,
      blurb:    opponent.blurb,
      image:    opponent.image,
      friend:   friend_status(opponent.id, current_player_id)
    }
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
      select: %{id: u.id, username: u.username, blurb: u.blurb, image: u.image}
    )
  end

end
