defmodule K2pokerIo.TournamentTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament

  doctest K2pokerIo.Tournament

  setup do
    Helpers.create_tournament()
    player = Helpers.create_user("stu")
    params = %{
      name: "Test Tournament",
      private: false,
      user_id: player.id,
      rebuys: [0],
    }
    changeset = Tournament.changeset(%Tournament{}, params)
    tournament = Repo.insert!(changeset) |> Repo.preload(:user)
    %{tournament: tournament, player: player}
  end

  test "#default should return the default tournament" do
    default_tournament = Repo.get_by(Tournament, default_tournament: true)
    assert(Tournament.default == default_tournament)
  end

  test "It should have a user", context do
    user = context.tournament.user
    assert(user.id == context.player.id)
  end

  test "It should have a name", context do
    tournament = context.tournament
    assert(tournament.name == "Test Tournament")
  end

  test "It should not be private", context do
    tournament = context.tournament
    refute(tournament.private)
  end

  test "It should have rebuys set", context do
    tournament = context.tournament
    assert(tournament.rebuys == [0])
  end

end
