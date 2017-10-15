defmodule K2pokerIo.NewChangesetTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Game
  alias K2pokerIo.Repo

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Game

  setup do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("bob")
    player_utd = Helpers.create_user_tournament_detail(player.username, tournament.id)
    params = %{
      player1_id: player_utd.player_id,
      tournament_id: player_utd.tournament_id,
      value: player_utd.current_score,
      waiting_for_players: true,
      open: true
      }
    changeset = Game.new_changeset(%Game{}, params)
    %{changeset: changeset, player_utd: player_utd}
  end

  test "#new_changeset with valid params", context do
    assert(context.changeset.valid?)
  end

  test "#new_changeset without player_id should err", context do
    player_utd = context.player_utd
    params = %{
      tournament_id: player_utd.tournament_id,
      value: player_utd.current_score,
      waiting_for_players: true,
      open: true
      }
    changeset = Game.new_changeset(%Game{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:player1_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "#new_changeset without tournament_id should err", context do
    player_utd = context.player_utd
    params = %{
      player1_id: player_utd.player_id,
      value: player_utd.current_score,
      waiting_for_players: true,
      open: true
      }
    changeset = Game.new_changeset(%Game{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:tournament_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "#new_changeset without value should err", context do
    player_utd = context.player_utd
    params = %{
      player1_id: player_utd.player_id,
      tournament_id: player_utd.tournament_id,
      waiting_for_players: true,
      open: true
      }
    changeset = Game.new_changeset(%Game{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:value]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "#new_changeset without waiting_for_players should err", context do
    player_utd = context.player_utd
    params = %{
      player1_id: player_utd.player_id,
      tournament_id: player_utd.tournament_id,
      value: player_utd.current_score,
      open: true
      }
    changeset = Game.new_changeset(%Game{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:waiting_for_players]
    assert(text == "must be accepted")
    assert(error == {:validation, :acceptance})
  end

  test "#new_changeset without open should err", context do
    player_utd = context.player_utd
    params = %{
      player1_id: player_utd.player_id,
      tournament_id: player_utd.tournament_id,
      value: player_utd.current_score,
      waiting_for_players: true
      }
    changeset = Game.new_changeset(%Game{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:open]
    assert(text == "must be accepted")
    assert(error == {:validation, :acceptance})
  end

  test "it should save the player_id", context do
    game = Repo.insert!(context.changeset)
    assert(game.player1_id == context.player_utd.player_id)
  end

  test "it should save the value", context do
    game = Repo.insert!(context.changeset)
    assert(game.value == context.player_utd.current_score)
  end

  test "it should be open", context do
    game = Repo.insert!(context.changeset)
    assert(game.open)
  end

  test "it should be waiting for players", context do
    game = Repo.insert!(context.changeset)
    assert(game.waiting_for_players)
  end

  test "it should belong to a tournament", context do
    game = Repo.insert!(context.changeset)
    assert(game.tournament_id == context.player_utd.tournament_id)
  end

  test "it should not have any game data", context do
    game = Repo.insert!(context.changeset)
    assert(game.data == nil)
  end

end
