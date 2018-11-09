defmodule K2pokerIo.QuitGameCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.JoinGameCommand
  alias K2pokerIo.Commands.Game.QuitGameCommand

  import Ecto.Query

  use K2pokerIoWeb.ConnCase

  doctest K2pokerIo.Commands.Game.QuitGameCommand

  setup do
    tournament = Helpers.create_tournament
    p1_utd = Helpers.create_user_tournament_detail("bob", tournament.id)
    p2_utd = Helpers.create_user_tournament_detail("stu", tournament.id)
    %{p1_utd: p1_utd, p2_utd: p2_utd, tournament: tournament}
  end

  test "it should quit the game and return true if other user has not joined", context do
    p1_utd = context.p1_utd
    JoinGameCommand.execute(p1_utd)
    p1_utd = Repo.get(UserTournamentDetail, p1_utd.id) |> Repo.preload([:game, :tournament])
    result = QuitGameCommand.execute(p1_utd)
    assert(result == true)
  end

  test "it should NOT be able to quit the game if other player has joined", context do
    p1_utd = context.p1_utd
    p2_utd = context.p2_utd
    JoinGameCommand.execute(p1_utd)
    JoinGameCommand.execute(p2_utd)
    p1_utd = Repo.get(UserTournamentDetail, p1_utd.id) |> Repo.preload([:game, :tournament])
    result = QuitGameCommand.execute(p1_utd)
    assert(result == false)
  end

end
