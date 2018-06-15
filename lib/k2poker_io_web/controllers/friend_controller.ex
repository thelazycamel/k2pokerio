defmodule K2pokerIoWeb.FriendController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Commands.User.DestroyFriendshipCommand
  alias K2pokerIo.Queries.Friends.FriendsQuery

  def index(conn, params) do
    if current_user(conn) do
      {query, pagination} = case params["area"] do
        "pending_me" -> FriendsQuery.pending_me(current_user(conn).id, params)
        "pending_them" -> FriendsQuery.pending_them(current_user(conn).id, params)
        _ -> FriendsQuery.friends_only(current_user(conn).id, params)
      end
      friends = FriendsQuery.decorate_friendships(query, current_user(conn).id)
      json(conn, %{friends: friends, pagination: pagination})
    else
      json conn, %{status: 401}
    end
  end

  def create(conn, %{"id" => friend_id}) do
    friend_id = convert_to_integer(friend_id)
    if current_user(conn) do
      status = RequestFriendCommand.execute(current_user(conn).id, friend_id)
      json conn, %{friend: status}
    else
      json conn, %{friend: :na}
    end
  end

  def confirm(conn, %{"id" => friend_id}) do
    friend_id = convert_to_integer(friend_id)
    if current_user(conn) do
      status = RequestFriendCommand.execute(current_user(conn).id, friend_id)
      json conn, %{friend: status}
    else
      json conn, %{friend: :na}
    end
  end

  def status(conn, %{"user_id" => user_id}) do
    status = FriendsQuery.find(current_user(conn).id, user_id)
      |> FriendDecorator.status(current_user(conn).id)
    json conn, %{show: status}
  end

  def count(conn, %{"action" => action}) do
    count = FriendsQuery.count(current_user(conn).id, action)
    json conn, %{action => count}
  end

  def search(conn, params) do
    %{"query" => query} = params
    if current_user(conn) do
      {users, pagination} = FriendsQuery.search_users(current_user(conn).id, query, params)
      friends = FriendsQuery.decorate_users(users, current_user(conn).id)
      json conn, %{friends: friends, pagination: pagination}
    else
      json conn, %{error: true, status: 401}
    end
  end

  def delete(conn, %{"id" => id}) do
    id = convert_to_integer(id)
    status = DestroyFriendshipCommand.execute(current_user(conn).id, id)
    json conn, %{friend: status}
  end

  defp convert_to_integer(friend_id) do
    if is_integer(friend_id), do: friend_id, else: String.to_integer(friend_id)
  end

end
