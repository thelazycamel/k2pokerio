defmodule K2pokerIo.Commands.User.DestroyFriendshipCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Queries.Friends.FriendsQuery

  def execute(current_user_id, friend_id) do
    find_friendship(current_user_id, friend_id)
    |> destroy_friendship
    :not_friends
  end

  defp find_friendship(current_user_id, friend_id) do
    FriendsQuery.find(current_user_id, friend_id)
  end

  defp destroy_friendship(friendship) do
    if friendship, do: Repo.delete!(friendship)
  end

end
