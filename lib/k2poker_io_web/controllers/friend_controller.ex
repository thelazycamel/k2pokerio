defmodule K2pokerIoWeb.FriendController do

  use K2pokerIoWeb, :controller

  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Commands.User.DestroyFriendshipCommand
  alias K2pokerIo.Queries.Friends.FriendsQuery
  alias K2pokerIo.Queries.Friends.SearchFriendsQuery

  def index(conn, _) do
    if current_user(conn) do
      friends =  FriendsQuery.all_and_pending(current_user(conn).id)
      json conn, %{friends: friends}
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

  def search(conn, %{"query" => query}) do
    if current_user(conn) do
      friends = SearchFriendsQuery.search(current_user(conn).id, query)
      json conn, %{friends: friends}
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
