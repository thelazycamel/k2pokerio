defmodule K2pokerIo.TournamentControllerTest do

  use K2pokerIoWeb.ConnCase

  alias K2pokerIo.Commands.User.RequestFriendCommand
  alias K2pokerIo.User
  alias K2pokerIo.Test.Helpers
  import Plug.Test

  doctest K2pokerIoWeb.TournamentController

  setup do
    tournament = Helpers.create_tournament()
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    RequestFriendCommand.execute(player1.id, player2.id)
    RequestFriendCommand.execute(player2.id, player1.id)
    %{player1: player1, player2: player2, tournament: tournament}
  end

  test "#index should show tournament index page for logged in user", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player2))
    response = conn
      |> get(tournament_path(conn, :index))
      |> response(200)
    expected = ~r/body\ class=.tournament\ index./
    assert(response =~ expected)
  end

  test "#index should redirect to root if not signed in", context do
    conn = context.conn
    response = conn
      |> get(tournament_path(conn, :index))
      |> response(302)
    expected = ~r/redirected/
    assert(response =~ expected)
  end

  test "#index should redirect to games play if anon user", context do
    anon_user = Helpers.create_user_tournament_detail("bob", context.tournament.id)
    conn = init_test_session(context.conn, player_id: anon_user.player_id)
    response = conn
      |> get(tournament_path(conn, :index))
      |> response(302)
    expected = ~r/redirected/
    assert(response =~ expected)
  end

  test "#show should redirect to root player does not have access to tournament", context do
    private_tournament = Helpers.create_private_tournament(context.player2, "Private Tourney")
    conn = init_test_session(context.conn, player_id: User.player_id(context.player2))
    response = conn
      |> get(tournament_path(conn, :show, private_tournament.id))
      |> response(302)
    expected = ~r/redirected/
    assert(response =~ expected)
  end


  test "#show should redirect to root if not signed in", context do
    conn = context.conn
    response = conn
      |> get(tournament_path(conn, :show, context.tournament.id))
      |> response(302)
    expected = ~r/redirected/
    assert(response =~ expected)
  end

  test "#show should return 200 if signed in and tournament accessible", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> get(tournament_path(conn, :show, context.tournament.id))
      |> response(200)
    expected = ~r/body\ class=.tournament\ show./
    assert(response =~ expected)
  end

  test "#join should join the tournament and redirect user to the game play", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player2))
    response = conn
      |> get(tournament_path(conn, :join, context.tournament.id))
      |> response(302)
    expected = ~r/You\ are\ being\ \<a\ href=.\/games\/play/
    #TODO we should assert that the conn has put_session :utd_id
    assert(response =~ expected)
  end

  test "#join should redirect to root if the tournament is not available to the user", context do
    private_tournament = Helpers.create_private_tournament(context.player2, "Player 1 not invited")
    conn = init_test_session(context.conn, player_id: User.player_id(context.player2))
    response = conn
      |> get(tournament_path(conn, :join, private_tournament.id))
      |> response(302)
    expected = ~r/You\ are\ being\ \<a\ href="\/"/
    assert(response =~ expected)
  end

  test "#new should render the new tournament page for a logged in user", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player2))
    response = conn
      |> get(tournament_path(conn, :new))
      |> response(200)
    expected = ~r/\<body\ class="tournament new"/
    assert(response =~ expected)
  end

  test "#new should redirect if user is not logged in", context do
    conn = context.conn
    response = conn
      |> get(tournament_path(conn, :new))
      |> response(302)
    expected = ~r/You\ are\ being\ \<a\ href="\/"/
    assert(response =~ expected)
  end

  test "#create should create a new tournament and return the tournament_id as json", context do
    friend_ids = [context.player2.id]
    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(tournament_path(conn, :create, %{"game_type" => "duel", "friend_ids" => friend_ids}))
      |> json_response(200)
      %{"status" => status, "id" => _} = response
    assert(status == "ok")
  end

  test "#create should return json error if not logged in", context do
    friend_ids = [context.player2.id]
    conn = context.conn
    response = conn
      |> post(tournament_path(conn, :create, %{"tournament" => %{"game_type" => "duel", "friend_ids" => friend_ids}}))
      |> response(401)
    %{"status" => status, "message" => _} = Poison.decode!(response)
    assert(status == "error")
  end

end
