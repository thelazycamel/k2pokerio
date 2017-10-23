defmodule K2pokerIo.UserTournamentDetailTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.User
  alias K2pokerIo.Test.Helpers

  doctest K2pokerIo.UserTournamentDetail

  setup do
    tournament = Helpers.create_tournament()
    user = Helpers.create_user("stu")
    player_id = User.player_id(user)
    %{player_id: player_id,
      tournament_id: tournament.id,
      username: user.username,
      current_score: 1,
      rebuys: [0]}
  end

  test "validates player_id", context do
    params = Map.merge(context, %{player_id: nil})
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:player_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "validates username", context do
    params = Map.merge(context, %{username: nil})
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:username]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "validates tournament", context do
    params = Map.merge(context, %{tournament_id: nil})
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:tournament_id]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "validates current_score", context do
    params = Map.merge(context, %{current_score: nil})
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:current_score]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "validates rebuys", context do
    params = Map.merge(context, %{rebuys: nil})
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, params)
    refute(changeset.valid?)
    {text, [error]} = changeset.errors[:rebuys]
    assert(text == "can't be blank")
    assert(error == {:validation, :required})
  end

  test "creates a valid changeset", context do
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, context)
    assert(changeset.valid?)
  end

end
