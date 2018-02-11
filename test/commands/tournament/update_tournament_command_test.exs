defmodule K2pokerIo.UpdateTournamentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Tournament.UpdateTournamentCommand
  alias K2pokerIo.User
  alias K2pokerIo.UserTournamentDetail

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.UpdateTournamentCommand

  setup do
    %{player1: Helpers.create_user("stu"), player2: Helpers.create_user("bob")}
  end

  test "it should close the tournament if duel", context do
    player1 = context.player1
    player2 = context.player2
    duel = Helpers.create_duel(player1, context.player2)
    p1_utd = Helpers.create_user_tournament_detail(User.player_id(player1), "stu", duel.id)
    p2_utd = Helpers.create_user_tournament_detail(User.player_id(player2), "bob", duel.id)
    game = Helpers.create_game([p1_utd, p2_utd])
    Repo.update!(UserTournamentDetail.changeset(p1_utd, %{current_score: 1048576}))
  end

  test "it should close the tournament if private", context do
  end

  test "it should not close the tournament if default", context do
  end

end
