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

  test "#request - should create a friend request, pending them to confirm", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(friend_path(conn, :request, %{"id" => context.player2.id}))
      |> json_response(200)
    %{"friend" => status} = response
    assert(status == "pending_them")
  end

  test "#request - should confirm a friend request, if other user has already requested", context do
    RequestFriendCommand.execute(context.player2.id, context.player1.id)
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(friend_path(conn, :request, %{"id" => context.player2.id}))
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

  @tag :skip
  test "#search it should return the current_users friends with given search params" do
    #TODO the controller action for this is not implemented yet
  end

end
