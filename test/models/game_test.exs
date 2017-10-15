defmodule K2pokerIo.GameTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Game
  alias K2pokerIo.Repo

  doctest K2pokerIo.Game

  setup do
    tournament = Helpers.create_tournament()
    bob = Helpers.create_user("bob")
    stu = Helpers.create_user("stu")
    player1_utd = Helpers.create_user_tournament_detail(bob.username, tournament.id)
    player2_utd = Helpers.create_user_tournament_detail(stu.username, tournament.id)
    params = %{
      player1_id: player1_utd.player_id,
      tournament_id: player1_utd.tournament_id,
      value: player1_utd.current_score,
      waiting_for_players: true,
      open: true
      }
    new_changeset = Game.new_changeset(%Game{}, params)
    game = Repo.insert!(new_changeset)
    new_params = %{player2_id: player2_utd.player_id, waiting_for_players: false}
    join_changeset = Game.join_changeset(game, new_params)
    game = Repo.update!(join_changeset)
    %{game: game, player1_utd: player1_utd, player2_utd: player2_utd, tournament: tournament}
  end

  test "it should have player1", context do
    assert(context.game.player1_id == context.player1_utd.player_id)
  end

  test "it should have player2", context do
    assert(context.game.player2_id == context.player2_utd.player_id)
  end

  test "it should have a value set", context do
    assert(context.game.value == 1)
  end

  test "it should be open", context do
    assert(context.game.open)
  end

  test "it should not have paid p1", context do
    refute(context.game.p1_paid)
  end

  test "it should not have paid p2", context do
    refute(context.game.p2_paid)
  end

  test "it should be waiting for players", context do
    refute(context.game.waiting_for_players)
  end

  test "it should belong to a tournament", context do
    assert(context.game.tournament_id == context.tournament.id)
  end

  test "it should have some game data", context do
    game_data = Game.decode_game_data(context.game.data)
    assert(game_data.status == "deal")
  end


end
