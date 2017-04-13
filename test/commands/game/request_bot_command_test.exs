defmodule K2pokerIo.RequestBotCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Game
  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.Game.JoinCommand
  alias K2pokerIo.Commands.Game.RequestBotCommand

  use K2pokerIo.ConnCase

  setup do
    tournament = Helpers.create_tournament
    p1_utd = Helpers.create_user_tournament_detail("bob", tournament.id)
    p2_utd = Helpers.create_user_tournament_detail("stu", tournament.id)
    %{p1_utd: p1_utd, p2_utd: p2_utd, tournament: tournament}
  end

  test "It should do nothing if an opponent exists", context do
    {:ok, _} = JoinCommand.execute(context.p1_utd)
    {:ok, game} = JoinCommand.execute(context.p2_utd)
    request = RequestBotCommand.execute(game.id)
    game_data = Game.decode_game_data(game.data)
    game_data_player_ids = Enum.map(game_data.players, fn(p) -> p.id end)
    assert(request == {:error})
    assert(Enum.member?(game_data_player_ids, context.p2_utd.player_id))
    assert(game.player2_id == context.p2_utd.player_id)
  end

  test "It should set the bot if no opponent exists", context do
    {:ok, game} = JoinCommand.execute(context.p1_utd)
    {:ok, game} = RequestBotCommand.execute(game.id)
    game_data = Game.decode_game_data(game.data)
    game_data_player_ids = Enum.map(game_data.players, fn(p) -> p.id end)
    assert(Enum.member?(game_data_player_ids, "BOT"))
    assert(game.player2_id == "BOT")
  end

end
