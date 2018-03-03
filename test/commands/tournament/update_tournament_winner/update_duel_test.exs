defmodule K2pokerIo.UpdateTournament.UpdateDuelTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand
  alias K2pokerIo.User
  alias K2pokerIo.Game
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.UpdateTournamentWinnerCommand

  setup do
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")
    duel = Helpers.create_duel(player1, player2)
    p1_utd = Helpers.create_user_tournament_detail(User.player_id(player1), "stu", duel.id)
    p2_utd = Helpers.create_user_tournament_detail(User.player_id(player2), "bob", duel.id)
    game = Helpers.create_game([p1_utd, p2_utd])
    game = Repo.get(Game, game.id) |> Repo.preload(:tournament)
    Repo.update!(UserTournamentDetail.changeset(p1_utd, %{current_score: 1048576}))
    %{game: game, p1_utd: p1_utd, p2_utd: p2_utd}
  end

  test "it should close the tournament if duel", context do
    UpdateTournamentWinnerCommand.execute(context.game, context.p1_utd)
    tournament = Repo.get(Tournament, context.game.tournament_id)
    assert(tournament.finished)
  end

end
