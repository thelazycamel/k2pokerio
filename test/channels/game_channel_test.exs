defmodule K2pokerIo.GameChannelTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIoWeb.GameChannel
  alias K2pokerIo.Game
  alias K2pokerIo.User
  alias K2pokerIo.Badge

  use K2pokerIoWeb.ChannelCase

  doctest K2pokerIoWeb.GameChannel

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
    close(socket)
  end

  test "game:bot_request" do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("BobTheTester")
    player_id = User.player_id(player)
    utd = Helpers.create_user_tournament_detail(player_id, player.username, tournament.id)

    {:ok, game} = Helpers.join_game(utd)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{game.id}")

    ref = push(socket, "game:bot_request", %{})
    assert_broadcast "game:new_game_data", %{}
    assert_reply(ref, :ok)

    game = Repo.get(Game, game.id)
    assert(game.player2_id == "BOT")
    close(socket)
  end

  test "game:game_discard", context do
    player_id = K2pokerIo.User.player_id(context.player1)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{ context.game.id}")
    ref = push(socket, "game:discard", %{"card_index" => "0"})
    assert_broadcast "game:new_game_data", %{}
    assert_reply(ref, :ok)

    game = Repo.get(Game, context.game.id)
    player_data = Game.player_data(game, player_id)
    assert(player_data.player_status == "discarded")
    close(socket)
  end

  test "game:fold", context do
    player_id = K2pokerIo.User.player_id(context.player1)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{ context.game.id}")
    ref = push(socket, "game:fold", %{})
    assert_broadcast "game:new_game_data", %{}
    assert_reply(ref, :ok)

    game = Repo.get(Game, context.game.id)
    player_data = Game.player_data(game, player_id)
    assert(player_data.player_status == "folded")
    close(socket)
  end

  test "game:badge_awarded sends message to user getting the badge", context do

    badge1 = Repo.insert!(%Badge{
      name: "Four Queens",
      description: "Win with four Queens",
      image: "queens",
      action: "4_queens",
      group: 5,
      position: 2,
      gold: false
    })

    badge2 = Repo.insert!(%Badge{
      name: "Four Kings",
      description: "Win with four Kings",
      image: "kings",
      action: "4_kings",
      group: 5,
      position: 3,
      gold: false
    })
    badges = [badge1,badge2]
    player_id = K2pokerIo.User.player_id(context.player1)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(GameChannel, "game:#{ context.game.id}")
    broadcast_from! socket, "game:badge_achieved", %{player_id: player_id, badges: badges}
    assert_push("game:badge_achieved", %{player_id: ^player_id, badges: badges})
    leave socket
  end

end
