defmodule K2pokerIo.Commands.User.DestroyFriendshipCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Queries.Friends.FriendsQuery
  alias K2pokerIo.Friendship

  def execute(current_user_id, friend_id) do
    find_friendships(current_user_id, friend_id)
    |> destroy_friendships
  end

  defp find_friendships(current_user_id, friend_id) do
    FriendsQuery.find(current_user_id, friend_id)
  end

  defp destroy_friendships(friendships) do
    Enum.each(friendships, fn (friendship) -> Repo.delete!(friendship) end)
    :not_friends
  end

end
