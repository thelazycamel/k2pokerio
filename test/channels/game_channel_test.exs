defmodule K2pokerIo.GameChannelTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIoWeb.GameChannel
  alias K2pokerIo.Game
  alias K2pokerIo.User

  use K2pokerIoWeb.ChannelCase

  doctest K2pokerIoWeb.GameChannel

  #TODO these tests create DBConnectionErrors

  setup do
    Helpers.advanced_set_up(["bob", "stu"])
  end

  test "game:game_play", context do
    player_id = K2pokerIo.User.player_id(context.player1)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{ context.game.id}")
    assert push(socket, "game:play", %{})
    assert_broadcast "game:new_game_data", %{}

    game = Repo.get(Game, context.game.id)
    player_data = Game.player_data(game, player_id)
    assert(player_data.player_status == "ready")
    leave(socket)
  end

  @tag :skip
  test "game:bot_request" do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("bob")
    player_id = User.player_id(player)
    utd = Helpers.create_user_tournament_detail(player_id, player.username, tournament.id)

    {:ok, game} = Helpers.join_game(utd)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{game.id}")

    assert push(socket, "game:bot_request", %{})
    assert_broadcast "game:new_game_data", %{}

    game = Repo.get(Game, game.id)
    assert(game.player2_id == "BOT")
    leave(socket)
  end

  @tag :skip
  test "game:game_discard", context do
    player_id = K2pokerIo.User.player_id(context.player1)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{ context.game.id}")
    assert push(socket, "game:discard", %{"card_index" => "0"})
    assert_broadcast "game:new_game_data", %{}
    leave(socket)

    game = Repo.get(Game, context.game.id)
    player_data = Game.player_data(game, player_id)
    assert(player_data.player_status == "discarded")
  end

  @tag :skip
  test "game:fold", context do
    player_id = K2pokerIo.User.player_id(context.player1)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{ context.game.id}")
    assert push(socket, "game:fold", %{})
    assert_broadcast "game:new_game_data", %{}
    leave(socket)

    game = Repo.get(Game, context.game.id)
    player_data = Game.player_data(game, player_id)
    assert(player_data.player_status == "folded")
  end

end
