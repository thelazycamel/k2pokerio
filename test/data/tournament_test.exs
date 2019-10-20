defmodule K2pokerIo.TournamentTest do

  use K2pokerIo.DataCase, async: false

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament

  doctest K2pokerIo.Tournament

  setup do
    Helpers.create_tournament()
    player = Helpers.create_user("stu")
    params = %{
      name: "Test Tournament",
      private: false,
      tournament_type: "tournament",
      lose_type: "all",
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

  test "It should validate name" do
    params = %{private: false, user_id: "123", rebuys: true, starting_chips: 1, max_score: 1048576, bots: true, lose_type: "all", finished: false, type: "tournament"}
    changeset = Tournament.changeset(%Tournament{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:name]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "It should validate type" do
    params = %{name: "test tourney", private: false, user_id: "123", rebuys: true, starting_chips: 1, max_score: 1048576, bots: true, lose_type: "all", finished: false}
    changeset = Tournament.changeset(%Tournament{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:tournament_type]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "It should validate lose_type" do
    params = %{name: "test tourney", private: false, user_id: "123", rebuys: true, starting_chips: 1, max_score: 1048576, bots: true, finished: false, type: "tournament"}
    changeset = Tournament.changeset(%Tournament{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:lose_type]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

end
