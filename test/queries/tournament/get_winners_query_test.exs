defmodule K2pokerIo.GetWinnersQuery do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Queries.Tournaments.GetWinnersQuery

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Queries.Tournaments.GetWinnersQuery

  setup do
    Helpers.advanced_set_up(["bob","stu"])
  end

  test "it should return the player and the winner", context do
    p1_utd = Repo.update!(UserTournamentDetail.changeset(context.p1_utd, %{current_score: 1024}))
    p2_utd = Repo.update!(UserTournamentDetail.changeset(context.p2_utd, %{current_score: 2048}))
    winners = GetWinnersQuery.current_winners(p1_utd.player_id, context.tournament)
    assert(winners.current_player.current_score == p1_utd.current_score)
    assert(winners.current_player.username == p1_utd.username)
    assert(winners.other_player.current_score == p2_utd.current_score)
    assert(winners.other_player.username == p2_utd.username)
  end

  test "it should return the next best player if the winner is the current user", context do
    p1_utd = Repo.update!(UserTournamentDetail.changeset(context.p1_utd, %{current_score: 2048}))
    p2_utd = Repo.update!(UserTournamentDetail.changeset(context.p2_utd, %{current_score: 1024}))
    winners = GetWinnersQuery.current_winners(p1_utd.player_id, context.tournament)
    assert(winners.current_player.current_score == p1_utd.current_score)
    assert(winners.other_player.current_score == p2_utd.current_score)
  end

end
