defmodule K2pokerIo.FriendControllerTest do

  use K2pokerIoWeb.ConnCase
  import Plug.Test

  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User

  doctest K2pokerIoWeb.FriendController

  setup do
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    %{player1: player1, player2: player2}
  end

  test "#index - should return a JSON representation of users friends", context do
    player3 = Helpers.create_user("pip")
    RequestFriendCommand.execute(context.player1.id, context.player2.id)
    RequestFriendCommand.execute(context.player1.id, player3.id)
    RequestFriendCommand.execute(context.player2.id, context.player1.id)
    RequestFriendCommand.execute(player3.id, context.player1.id)
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> get(friend_path(conn, :index))
      |> json_response(200)
    %{"friends" => friends} = response
    first_friend = List.first(friends)
    assert(Enum.count(friends) == 2)
    assert(first_friend["username"] == "bob")
    assert(first_friend["status"]== "friend")
  end

  test "#create - should create a friend request, pending them to confirm", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(friend_path(conn, :create, %{"id" => context.player2.id}))
      |> json_response(200)
    %{"friend" => status} = response
    assert(status == "pending_them")
  end

  test "#create - should confirm a friend request, if other user has already requested", context do
    RequestFriendCommand.execute(context.player2.id, context.player1.id)
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(friend_path(conn, :create, %{"id" => context.player2.id}))
      |> json_response(200)
    %{"friend" => status} = response
    assert(status == "friend")
  end

  test "#confirm - should confirm a friend request", context do
    RequestFriendCommand.execute(context.player2.id, context.player1.id)
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(friend_path(conn, :confirm, %{"id" => context.player2.id}))
      |> json_response(200)
    %{"friend" => status} = response
    assert(status == "friend")
  end

  test "#confirm - should not confirm a friend request, if the other player hasnt requested one", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(friend_path(conn, :confirm, %{"id" => context.player2.id}))
      |> json_response(200)
    %{"friend" => status} = response
    assert(status == "pending_them")
  end

end
