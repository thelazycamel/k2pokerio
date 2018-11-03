defmodule K2pokerIo.Commands.User.GetFriendStatusCommand do

  alias K2pokerIo.Queries.Friends.FriendsQuery
  alias K2pokerIo.Decorators.FriendDecorator

  def execute(user_id, opponent_id) do
    FriendsQuery.find(user_id, opponent_id)
    |> FriendDecorator.status(user_id)
  end

end
