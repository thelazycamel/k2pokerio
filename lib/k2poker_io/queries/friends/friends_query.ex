defmodule K2pokerIo.Queries.Friends.FriendsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Friendship

  import Ecto.Query

  def all(current_user_id) do
    Enum.concat(my_friends(current_user_id), i_am_friends_of(current_user_id))
    |> Enum.into(%{}, fn [id, username] -> {id, username} end)
  end

  def ids(current_user_id) do
    Enum.concat(my_friends(current_user_id), i_am_friends_of(current_user_id))
    |> Enum.map(fn [id, _] -> id end)
  end

  #private

  defp my_friends(current_user_id) do
    query = from f in Friendship,
      join: u in assoc(f, :friend),
      where: (f.user_id == ^current_user_id and f.status == true),
      select: [u.id, u.username]
    Repo.all(query)
  end

  defp i_am_friends_of(current_user_id) do
    query = from f in Friendship,
      join: u in assoc(f, :user),
      where: (f.friend_id == ^current_user_id and f.status == true),
      select: [u.id, u.username]
    Repo.all(query)
  end

end
