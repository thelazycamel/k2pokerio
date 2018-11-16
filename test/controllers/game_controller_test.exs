defmodule K2pokerIo.GameControllerTest do

  use K2pokerIoWeb.ConnCase
  import Plug.Test

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.User
  alias K2pokerIo.Game
  alias K2pokerIo.Repo

  import Ecto.Query


  doctest K2pokerIoWeb.GameController

  setup do
    Helpers.advanced_set_up(["bob","stu"])
  end

  test "#play should render play.html if all correct", context do
    player1_id = User.player_id(context.player1)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^context.tournament.id])
    conn = init_test_session(context.conn, %{utd_id: utd.id, player_id: player1_id})
    response = conn
      |> get(game_path(conn, :play))
      |> response(200)
    expected = ~r/\<body\ class\=.game play/
    assert(response =~ expected)
  end

  test "#play should redirect to root unless player", context do
    conn = init_test_session(context.conn, %{})
    response = conn
      |> get(game_path(conn, :play))
      |> response(302)
    expected = ~r/href="\/">redirected/
    assert(response =~ expected)
  end

  test "#play should redirect to tournament index unless user_tournament_detail", context do
    player1_id = User.player_id(context.player1)
    conn = init_test_session(context.conn, %{player_id: player1_id})
    response = conn
      |> get(game_path(conn, :play))
      |> response(302)
    expected = ~r/href="\/tournaments"\>redirected/
    assert(response =~ expected)
  end

  test "#join should join a new game for the tournament, via the user_tournament_detail", context do
    tournament = Helpers.create_private_tournament(context.player1, "bobs tourney")
    player1_id = User.player_id(context.player1)
    utd = Helpers.create_user_tournament_detail(player1_id, "bob", tournament.id)
    conn = init_test_session(context.conn, %{utd_id: utd.id, player_id: player1_id})
    response = conn
      |> post(game_path(conn, :join))
      |> json_response(200)
    game = Repo.one(from g in Game, where: [player1_id: ^player1_id, tournament_id: ^tournament.id])
    expected = %{ "status" => "ok",
                  "game_id" => game.id,
                  "joined" => true
                }
    assert(response == expected)
  end

  test "#join should rejoin a game, when already in a game", context do
    player1_id = User.player_id(context.player1)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^context.tournament.id])
    conn = init_test_session(context.conn, %{utd_id: utd.id, player_id: player1_id})
    response = conn
      |> post(game_path(conn, :join))
      |> json_response(200)
    expected = %{ "status" => "ok",
                  "game_id" => utd.game_id,
                  "joined" => true
                }
    assert(response == expected)
  end

  test "#join, should return an error when no user_tournament_detail for user", context do
    player1_id = User.player_id(context.player1)
    conn = init_test_session(context.conn, player_id: player1_id)
    response = conn
      |> post(game_path(conn, :join))
      |> json_response(200)
    expected = %{ "status" => "error" }
    assert(response == expected)
  end

  test "opponent_profile", context do
    player1_id = User.player_id(context.player1)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^context.tournament.id])
    conn = init_test_session(context.conn, %{utd_id: utd.id, player_id: player1_id})
    response = conn
      |> post(game_path(conn, :opponent_profile))
      |> json_response(200)
    expected = %{ "blurb" => nil,
                  "friend" => "not_friends",
                  "id" => context.player2.id,
                  "image" => nil,
                  "opponent" => "user",
                  "username" => context.player2.username,
                  "stats" => true,
                  "games_won" => 0,
                  "games_folded" => 0,
                  "games_lost" => 0,
                  "games_played" => 0,
                  "top_score" => 0,
                  "duels_won" => 0,
                  "tournaments_won" => 0
                }
    assert(response == expected)
  end

  test "player_score", context do
    player1_id = User.player_id(context.player1)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^context.tournament.id])
    conn = init_test_session(context.conn, %{utd_id: utd.id, player_id: player1_id})
    response = conn
      |> post(game_path(conn, :player_score))
      |> json_response(200)
    expected = %{ "current_score" => utd.current_score,
                  "username" => context.player1.username }
    assert(response == expected)
  end

end
