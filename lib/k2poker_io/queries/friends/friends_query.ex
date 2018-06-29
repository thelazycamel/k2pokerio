defmodule K2pokerIo.Queries.Friends.FriendsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Friendship
  alias K2pokerIo.User
  alias K2pokerIo.Decorators.FriendDecorator

  import Ecto.Query

  def find(current_user_id, friend_id) do
    query = from f in Friendship,
      where: f.user_id == ^current_user_id and f.friend_id == ^friend_id,
      or_where: f.user_id == ^friend_id and f.friend_id == ^current_user_id,
      limit: 1
    Repo.one(query)
  end

  def all(current_user_id, params) do
    query = from f in Friendship,
      where: [user_id: ^current_user_id],
      or_where: [friend_id: ^current_user_id],
      order_by: [f.id],
      preload: [:user, :friend]
    Repo.paginate(query, params)
  end

  #TODO order by username
  def friends_only(current_user_id, params) do
    query = from f in Friendship,
      where: [user_id: ^current_user_id, status: true],
      or_where: [friend_id: ^current_user_id, status: true],
      preload: [:user, :friend]
    Repo.paginate(query, params)
  end

  #TODO order by username
  def pending_me(current_user_id, params) do
    query = from f in Friendship,
      where: [friend_id: ^current_user_id, status: false],
      preload: [:user]
    Repo.paginate(query, params)
  end

  #TODO order by username
  def pending_them(current_user_id, params) do
    query = from f in Friendship,
      where: [user_id: ^current_user_id, status: false],
      preload: [:friend]
    Repo.paginate(query, params)
  end

  def count(current_user_id, action) do
    case action do
      "pending_me" -> Repo.one(from f in Friendship, select: count(f.id), where: [friend_id: ^current_user_id, status: false])
      "friends" -> Repo.one(from f in Friendship, select: count(f.id), where: [user_id: ^current_user_id, status: true], or_where: [friend_id: ^current_user_id, status: true] )
      "pending_them" -> Repo.one(from f in Friendship, select: count(f.id), where: [user_id: ^current_user_id, status: false])
       _ -> 0
    end
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

  def search_users(current_user_id, text, params) do
    query = from u in User,
      where: ilike(u.username, ^"%#{text}%") and (u.id != ^current_user_id),
      left_join: f in Friendship,
        on: (f.user_id == u.id and f.friend_id == ^current_user_id) or (f.user_id == ^current_user_id and f.friend_id == u.id),
      select: %{id: u.id, username: u.username, image: u.image, blurb: u.blurb, user_id: f.user_id, friend_id: f.friend_id, status: f.status},
      order_by: u.username
    Repo.paginate(query, params)
  end

  def decorate_users(query, current_user_id) do
    Enum.map(query, fn (user) ->
      FriendDecorator.user_decorator(user, current_user_id)
    end)
  end

  def decorate_friendships(query, current_user_id) do
    Enum.map(query, fn (friendship) ->
      FriendDecorator.decorate(friendship, current_user_id)
    end)
  end

end
