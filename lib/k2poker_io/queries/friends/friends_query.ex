defmodule K2pokerIo.Queries.Friends.FriendsQuery do

  #TODO this is horrible, must be able to do better than this...!

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

  def find(current_user_id, friend_id) do
    query = from f in Friendship,
      where: [user_id: ^current_user_id, friend_id: ^friend_id],
      or_where: [user_id: ^friend_id, friend_id: ^current_user_id]
    Repo.all(query)
  end

  # TODO order by pending_me, friends, pending_them
  # TODO paginate this method, pagination will be difficult as i am joining two queries and sorting them
  def all_and_pending(current_user_id) do
    Enum.concat(
      decorate(all_and_pending_them(current_user_id), "pending_them"),
      decorate(all_and_pending_me(current_user_id), "pending_me")
    )
  end

  #private

  def decorate(query, status) do
    Enum.map(query, fn (friend) ->
      if friend.status == false do
        Map.put(friend, :status, status)
      else
        Map.put(friend, :status, "friend")
      end
    end)
  end

  defp all_and_pending_them(current_user_id) do
    query = from f in Friendship,
      join: u in assoc(f, :friend),
      where: (f.user_id == ^current_user_id),
      select: %{id: u.id, username: u.username, image: u.image, blurb: u.blurb, status: f.status}
    Repo.all(query)
  end

  defp all_and_pending_me(current_user_id) do
    query = from f in Friendship,
      join: u in assoc(f, :user),
      where: (f.friend_id == ^current_user_id),
      select: %{id: u.id, username: u.username, image: u.image, blurb: u.blurb, status: f.status}
    Repo.all(query)
  end


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
