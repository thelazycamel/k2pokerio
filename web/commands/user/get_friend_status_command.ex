defmodule K2pokerIo.Commands.User.GetFriendStatusCommand do

  alias K2pokerIo.User
  alias K2pokerIo.Friendship
  alias K2pokerIo.Repo
  import Ecto
  import Ecto.Query

  def execute(user_id, opponent_id) do
    get_friendship_status(user_id, opponent_id)
  end

  defp get_friendship_status(user_id, opponent_id) do
   case are_they_my_friend(user_id, opponent_id) do
     false -> :pending_them
     true -> :friend
     nil -> or_i_could_be_their_friend(user_id, opponent_id)
   end
  end

  defp or_i_could_be_their_friend(user_id, opponent_id) do
    case i_am_their_friend(user_id, opponent_id) do
     false -> :pending_me
     true -> :friend
     nil -> :not_friends
    end
  end


  def are_they_my_friend(user_id, opponent_id) do
    query =from u in Friendship,
      where: fragment("user_id = ? and friend_id = ?", ^user_id, ^opponent_id),
      select: u.status,
      limit: 1
    Repo.one(query)
  end

  def i_am_their_friend(user_id, opponent_id) do
    query = from u in Friendship,
      where: fragment("friend_id = ? and user_id = ?", ^user_id, ^opponent_id),
      select: u.status,
      limit: 1
    Repo.one(query)
  end

end
