defmodule K2pokerIoWeb.Helpers.FriendsHelper do

  alias K2pokerIo.Queries.Friends.FriendsQuery

  def friend_requests(current_user) do
    FriendsQuery.count(current_user.id, "pending_me")
  end

end
