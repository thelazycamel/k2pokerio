defmodule K2pokerIo.GameControllerTest do

  use K2pokerIoWeb.ConnCase
  import Plug.Test

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.User
  alias K2pokerIo.Repo

  import Ecto.Query


  doctest K2pokerIoWeb.GameController

  setup do
    Helpers.advanced_set_up(["bob","stu"])
  end

  @tag :skip
  test "play", context do
    #TODO
    assert(context)
  end

  @tag :skip
  test "join", context do
    #TODO
    assert(context)
  end

  test "opponent_profile", context do
    player1_id = User.player_id(context.player1)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^context.tournament.id])
    conn = init_test_session(context.conn, utd_id: utd.id)
      |> init_test_session(player_id: User.player_id(context.player1))
    response = conn
      |> post(game_path(conn, :opponent_profile))
      |> json_response(200)
    expected = %{ "blurb" => nil,
                 "friend" => "not_friends",
                 "id" => context.player2.id,
                 "image" => nil,
                 "opponent" => "user",
                 "username" => context.player2.username
                 }
    assert(response == expected)
  end

  @tag :skip
  test "player_score", context do
    #TODO
    assert(context)
  end

end
