defmodule K2pokerIo.JoinGameCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.JoinGameCommand

  import Ecto.Query

  use K2pokerIoWeb.ConnCase

  doctest K2pokerIo.Commands.Game.JoinGameCommand

  setup do
    tournament = Helpers.create_tournament
    p1_utd = Helpers.create_user_tournament_detail("bob", tournament.id)
    p2_utd = Helpers.create_user_tournament_detail("stu", tournament.id)
    %{p1_utd: p1_utd, p2_utd: p2_utd, tournament: tournament}
  end

  test "it should reset the players score if they have reached the max score", context do
    p1_utd = Repo.update!(UserTournamentDetail.changeset(context.p1_utd, %{current_score: 1048576}))
    assert(p1_utd.current_score == 1048576)
    JoinGameCommand.execute(p1_utd)
    p1_utd = Repo.get(UserTournamentDetail, p1_utd.id)
    assert(p1_utd.current_score == 1)
  end

  test "it should create a new game if one does not exist", context do
    {:ok, game} = JoinGameCommand.execute(context.p1_utd)
    assert(game.player1_id == context.p1_utd.player_id)
    assert(game.tournament_id == context.tournament.id)
    assert(game.value == 1)
    assert(game.waiting_for_players == true)
    assert(game.open == true)
  end

  test "it should find a game that already exists", context do
    JoinGameCommand.execute(context.p1_utd)
    {:ok, game} = JoinGameCommand.execute(context.p2_utd)
    assert(game.player1_id == context.p1_utd.player_id)
    assert(game.player2_id == context.p2_utd.player_id)
    assert(game.tournament_id == context.tournament.id)
    assert(game.value == 1)
    assert(game.waiting_for_players == false)
    assert(game.open == true)
  end

  test "it should update the users tournament detail with the new game id", context do
    JoinGameCommand.execute(context.p1_utd)
    {:ok, game} = JoinGameCommand.execute(context.p2_utd)
    p1_utd = Repo.get(UserTournamentDetail, context.p1_utd.id)
    p2_utd = Repo.get(UserTournamentDetail, context.p2_utd.id)
    assert(p1_utd.game_id == game.id)
    assert(p2_utd.game_id == game.id)
  end


end
