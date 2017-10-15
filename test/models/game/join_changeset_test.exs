defmodule K2pokerIo.JoinChangesetTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Game
  alias K2pokerIo.Repo

  use K2pokerIoWeb.ConnCase

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
    changeset = Game.create_new_changeset(%Game{}, params)
    game = Repo.insert!(changeset)
    %{game: game, player1_utd: player1_utd, player2_utd: player2_utd}
  end

  test "#join_changeset -> creates a changeset with a current game and a new player", context do
    player2_utd = context.player2_utd
    game = context.game
    new_params = %{player2_id: player2_utd.player_id, waiting_for_players: false}
    join_changeset = Game.join_changeset(game, new_params)
    assert(join_changeset.valid?)
  end

  test "#join_changeset -> validates player2", context do
    game = context.game
    new_params = %{waiting_for_players: false}
    join_changeset = Game.join_changeset(game, new_params)
    refute(join_changeset.valid?)
    {text, [error]} = join_changeset.errors[:player2_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "#join_changeset -> it should add the new player", context do
    player2_utd = context.player2_utd
    game = context.game
    new_params = %{player2_id: player2_utd.player_id, waiting_for_players: false}
    join_changeset = Game.join_changeset(game, new_params)
    game = Repo.update!(join_changeset)
    assert(game.player2_id == player2_utd.player_id)
  end

  test "#join_changeset -> the game should no longer be waiting for players", context do
    player2_utd = context.player2_utd
    game = context.game
    new_params = %{player2_id: player2_utd.player_id, waiting_for_players: false}
    join_changeset = Game.join_changeset(game, new_params)
    game = Repo.update!(join_changeset)
    refute(game.waiting_for_players)
  end

  test "#join_changeset -> the game should hold some game data", context do
    player2_utd = context.player2_utd
    game = context.game
    new_params = %{player2_id: player2_utd.player_id, waiting_for_players: false}
    join_changeset = Game.join_changeset(game, new_params)
    game = Repo.update!(join_changeset)
    game_data = Game.decode_game_data(game.data)
    assert(game_data.status == "deal")
  end

end
