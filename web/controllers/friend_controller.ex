defmodule K2pokerIo.FriendController do

  use K2pokerIo.Web, :controller
  alias K2pokerIo.Commands.User.RequestFriendCommand

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

  def destroy do

  end

end
