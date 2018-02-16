defmodule K2pokerIo.UpdateTournament.UpdateOpenTournamentTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Tournament.UpdateTournamentCommand
  alias K2pokerIo.User
  alias K2pokerIo.Game
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail

  use K2pokerIo.ModelCase
  import Ecto.Query

  doctest K2pokerIo.Commands.Tournament.UpdateTournamentCommand

  setup do
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    tournament = Helpers.create_open_tournament(player1, "Friday Rush")
    p1_utd = Helpers.create_user_tournament_detail(User.player_id(player1), "stu", tournament.id)
    p2_utd = Helpers.create_user_tournament_detail(User.player_id(player2), "stu", tournament.id)
    game = Helpers.create_game([p1_utd, p2_utd])
    %{tournament: tournament, player1: player1, player2: player2, game: game, p1_utd: p1_utd, p2_utd: p2_utd}
  end

  test "it should close the tournament if open tournament", context do
    p1_utd = Repo.update!(UserTournamentDetail.changeset(context.p1_utd, %{current_score: 1048576}))
    update = UpdateTournamentCommand.execute(context.game, p1_utd)
    tournament = Repo.get(Tournament, context.game.tournament_id)
    assert(tournament.finished)
  end

end
