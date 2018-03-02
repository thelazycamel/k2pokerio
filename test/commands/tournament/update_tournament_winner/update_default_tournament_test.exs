defmodule K2pokerIo.UpdateTournament.UpdateDefaultTournamentTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand
  alias K2pokerIo.User
  alias K2pokerIo.Game
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail

  use K2pokerIo.ModelCase
  import Ecto.Query

  doctest K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

  test "it should not close the tournament if default", context do
    p1_utd = Repo.update!(UserTournamentDetail.changeset(context.player1, %{current_score: 1048576})) |> Repo.preload(:tournament)
    update = UpdateTournamentWinnerCommand.execute(context.game, p1_utd)
    tournament = Repo.get(Tournament, context.game.tournament_id)
    refute(tournament.finished)
  end

end