defmodule K2pokerIo.FriendController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Queries.User.SearchFriendsQuery

  def request(conn, %{"id" => friend_id}) do
    if current_user(conn) do
      {friend_id, _} = Integer.parse(friend_id)
      status = RequestFriendCommand.execute(current_user(conn).id, friend_id)
      json conn, %{friend: status}
    else
      json conn, %{friend: :na}
    end
  end

  def confirm(conn, %{"id" => friend_id}) do
    if current_user(conn) do
      {friend_id, _} = Integer.parse(friend_id)
      status = RequestFriendCommand.execute(current_user(conn).id, friend_id)
      json conn, %{friend: status}
    else
      json conn, %{friend: :na}
    end
  end

  def search(conn, %{"query" => query, "game" => game_type}) do
    if current_user(conn) do
      friends = SearchFriendsQuery.search(current_user(conn).id, query)
      json conn, %{friends: friends}
    else
      json conn, %{error: true, status: 401}
    end
  end

  def destroy do

  end

end
