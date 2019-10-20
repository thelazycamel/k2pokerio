defmodule K2pokerIo.UpdateTournament.UpdateDefaultTournamentTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand

  setup do
    Helpers.basic_set_up(["bob", "stu"])
  end

  test "it should NOT close the tournament if default", context do
    p1_utd = Repo.update!(UserTournamentDetail.changeset(context.player1, %{current_score: 1048576})) |> Repo.preload(:tournament)
    UpdateTournamentWinnerCommand.execute(context.game, p1_utd)
    tournament = Repo.get(Tournament, context.game.tournament_id)
    refute(tournament.finished)
  end

end
