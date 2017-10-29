defmodule K2pokerIo.TournamentChannelTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIoWeb.TournamentChannel

  use K2pokerIoWeb.ChannelCase

  doctest K2pokerIoWeb.TournamentChannel

  setup do
    tournament = Helpers.create_tournament()
    user = Helpers.create_user("stu")
    %{user: user, tournament: tournament}
  end

  test "Joining broadcasts the new user count", context do
    {:ok, _, _} = socket("", %{current_user: context.user})
      |> subscribe_and_join(TournamentChannel, "tournament:#{ context.tournament.id}")
    assert_broadcast "tournament:update", %{player_count: 1, tournament_name: "The Big Kahuna"}
  end

end
