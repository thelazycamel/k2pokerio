defmodule K2pokerIo.Queries.Friends.FriendsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Friendship
  alias K2pokerIo.Decorators.FriendDecorator

  import Ecto.Query

  def find(current_user_id, friend_id) do
    query = from f in Friendship,
      where: f.user_id == ^current_user_id and f.friend_id == ^friend_id,
      or_where: f.user_id == ^friend_id and f.friend_id == ^current_user_id,
      limit: 1
    Repo.one(query)
  end

  def all(current_user_id) do
    query = from f in Friendship,
      where: [user_id: ^current_user_id],
      or_where: [friend_id: ^current_user_id],
      preload: [:user, :friend]
    Repo.all(query)
  end

  def friends_only(current_user_id) do
    query = from f in Friendship,
      where: [user_id: ^current_user_id, status: true],
      or_where: [friend_id: ^current_user_id, status: true],
      preload: [:user, :friend]
    Repo.all(query)
  end

  def pending_me(current_user_id) do
    query = from f in Friendship,
      where: [friend_id: ^current_user_id, status: false],
      preload: [:user]
    Repo.all(query)
  end

  def pending_them(current_user_id) do
    query = from f in Friendship,
      where: [user_id: ^current_user_id, status: false],
      preload: [:friend]
    Repo.all(query)
  end

  def ids(current_user_id) do
    Repo.all(from f in Friendship,
      where: [user_id: ^current_user_id, status: true],
      or_where: [friend_id: ^current_user_id, status: true]
    ) |>
    Enum.map(fn friendship ->
      if(friendship.user_id == current_user_id) do
        friendship.friend_id
      else
        friendship.user_id
      end
    end)
  end

  def decorate_users(query, current_user_id) do
    Enum.map(query, fn (friendship) ->
      FriendDecorator.decorate(friendship, current_user_id)
    end)
  end

end
