defmodule K2pokerIo.Queries.Friends.FriendsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Friendship
  import Ecto
  import Ecto.Query

  def all(current_user_id) do
    Enum.concat(my_friends(current_user_id), i_am_friends_of(current_user_id))
    |> Enum.into(%{}, fn [id, username] -> {id, username} end)
  end

  def ids(current_user_id) do
    Enum.concat(my_friends(current_user_id), i_am_friends_of(current_user_id))
    |> Enum.map(fn [id, username] -> id end)
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
    my_friends = Repo.all(query)
  end

  #TODO: above queries should be joined  to be one!
  # something like this is the best way of doing this query
  # i need to understand how to build these queries up and add them together

  def new_all(current_user_id) do
    query = Friendship
    |> all_my_friends(current_user_id)
    |> who_im_friends_of(current_user_id)
    |> Repo.all
  end

  def all_my_friends(query, current_user_id) do
    #query
    #|> from f in query,
    #  join: u in assoc(f, :friend),
    #  where: (f.user_id == ^current_user_id and f.status == true),
    #select: [u.id, u.username]
  end

  def who_im_friends_of(query, current_user_id) do
    # query
    #|> from f in query,
    # join: u in assoc(f, :user),
    #  where: (f.friend_id == ^current_user_id and f.status == true),
    #  select: [u.id, u.username]
  end



end
