defmodule K2pokerIo.ChatChannelTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIoWeb.ChatChannel
  alias K2pokerIo.User

  use K2pokerIoWeb.ChannelCase

  doctest K2pokerIoWeb.ChatChannel

  setup do
    tournament = Helpers.create_tournament()
    user = Helpers.create_user("stu")
    %{user: user, tournament: tournament}
  end

  test "Joining broadcasts the user has joined", context do
    player_id = User.player_id(context.user)
    tournament_id = "#{context.tournament.id}"
    {:ok, _, socket} = socket("", %{player_id: player_id, current_user: context.user})
      |> subscribe_and_join(ChatChannel, "chat:#{tournament_id}")
    assert_broadcast "chat:new_comment", %{id: _, username: "stu", comment: "has joined the tournament", admin: true}
    leave(socket)
  end

  test "chat:create_comment -> broadcasts the message", context do
    player_id = User.player_id(context.user)
    tournament_id = "#{context.tournament.id}"
    {:ok, _, socket} = socket("", %{player_id: player_id, current_user: context.user})
      |> subscribe_and_join(ChatChannel, "chat:#{tournament_id}")
    push(socket, "chat:create_comment", %{"comment" => "Hello World", "tournament_id" => tournament_id})
    assert_broadcast "chat:new_comment", %{id: _, username: "stu", comment: "Hello World", admin: nil}
    leave(socket)
  end


end
