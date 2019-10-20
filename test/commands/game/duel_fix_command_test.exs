defmodule K2pokerIo.DuelFixCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Game
  alias K2pokerIo.User
  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.Game.DuelFixCommand

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Commands.Game.DuelFixCommand

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    duel = Helpers.create_duel(player1, player2)
    %{duel: duel, player1: player1, player2: player2}
  end

  test "it should return ok unless the game is a duel", context do
    player1 = context.player1
    player_id = User.player_id(player1)
    tournament = Helpers.create_private_tournament(player1, "privte tourney")
    utd = Helpers.create_user_tournament_detail(player_id, "bob", tournament.id)
    result = DuelFixCommand.execute(utd)
    assert(result == :ok)
  end

  test "it should return ok if only one game waiting", context do
    player1 = context.player1
    player_id = User.player_id(player1)
    utd = Helpers.create_user_tournament_detail(player_id, "bob", context.duel.id)
    result = DuelFixCommand.execute(utd)
    assert(result == :ok)
  end

  test "it should return :updated and destroy one game, if 2 games were created", context do
    duel = context.duel
    player1 = context.player1
    player1_id = User.player_id(player1)
    player2 = context.player2
    player2_id = User.player_id(player2)
    p1_utd = Helpers.create_user_tournament_detail(player1_id, "bob", duel.id)
    p2_utd = Helpers.create_user_tournament_detail(player2_id, "stu", duel.id)
    Repo.insert(Game.new_changeset(%Game{}, %{player1_id: player1_id, p1_timestamp: NaiveDateTime.utc_now, tournament_id: p1_utd.tournament_id, value: p1_utd.current_score, waiting_for_players: true, open: true}))
    Repo.insert(Game.new_changeset(%Game{}, %{player1_id: player2_id, p1_timestamp: NaiveDateTime.utc_now, tournament_id: p2_utd.tournament_id, value: p2_utd.current_score, waiting_for_players: true, open: true}))
    result = DuelFixCommand.execute(p1_utd)
    assert(result == :updated)
    query = from Game, where: [ tournament_id: ^p1_utd.tournament_id, waiting_for_players: true ]
    games = Repo.all(query)
    assert(Enum.count(games) == 1)
  end

end
