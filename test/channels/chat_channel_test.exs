defmodule K2pokerIo.ChatChannelTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIoWeb.ChatChannel
  alias K2pokerIo.User
  alias K2pokerIo.Repo

  use K2pokerIoWeb.ChannelCase

  doctest K2pokerIoWeb.ChatChannel


  #TODO write more specs here around getting the list of last 10 and owner an non-owner receiving

  setup do
    tournament = Helpers.create_tournament()
    user = Helpers.create_user("stu")
    %{user: user, tournament: tournament}
  end

  test "chat:create_comment -> broadcasts the message (user has no profile image)", context do
    player_id = User.player_id(context.user)
    tournament_id = "#{context.tournament.id}"
    {:ok, _, socket} = socket("", %{player_id: player_id, current_user: context.user})
      |> subscribe_and_join(ChatChannel, "chat:#{tournament_id}")
    push(socket, "chat:create_comment", %{"comment" => "Hello World", "tournament_id" => tournament_id})
    assert_broadcast "chat:new_comment", %{}
    assert_receive %Phoenix.Socket.Message{payload: %{chat_id: _, username: "stu", image: "/images/profile-images/fish.png", comment: "Hello World", admin: false, owner: true}}
    leave(socket)
  end

  test "chat:create_comment -> broadcasts the message with profile image", context do
    user = Repo.update!(User.profile_changeset(context.user, %{image: "/images/profile-images/bond.png"}))
    player_id = User.player_id(user)
    profile_image = user.image
    tournament_id = "#{context.tournament.id}"
    {:ok, _, socket} = socket("", %{player_id: player_id, current_user: user})
      |> subscribe_and_join(ChatChannel, "chat:#{tournament_id}")
    push(socket, "chat:create_comment", %{"comment" => "Hello World", "tournament_id" => tournament_id})
    assert_broadcast "chat:new_comment", %{}
    assert_receive %Phoenix.Socket.Message{payload: %{chat_id: _, username: "stu", image: ^profile_image, comment: "Hello World", admin: false, owner: true}}
    leave(socket)
  end

  test "can send an admin broadcast from anywhere within the app", context do
    player_id = User.player_id(context.user)
    tournament_id = "#{context.tournament.id}"
    {:ok, _, socket} = socket("", %{player_id: player_id, current_user: context.user})
      |> subscribe_and_join(ChatChannel, "chat:#{tournament_id}")
    payload = %{chat_id: "abc123", username: "thelazycamel", comment: "Has reached the K2 Summit", admin: true }
    K2pokerIoWeb.Endpoint.broadcast! "chat:#{tournament_id}", "chat:admin_message", payload
    assert_receive %Phoenix.Socket.Message{payload: %{chat_id: "abc123", username: "thelazycamel", comment: "Has reached the K2 Summit", admin: true}}
    leave(socket)
  end

end
