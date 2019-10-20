defmodule K2pokerIo.UserTournamentDetailTest do

  use K2pokerIo.DataCase, async: false

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

  test "creates a user_id if real user", context do
    player = Helpers.create_user("bob")
    params = Map.merge(context, %{user_id: player.id})
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, params)
    utd = Repo.insert!(changeset)
    assert(changeset.valid?)
    assert(utd.user_id == player.id)
  end

  test "is_anon_user? should confirm is that user_tournament_detail belongs to an anon user", context do
    anon = Helpers.create_user_tournament_detail("bob", context.tournament_id)
    assert(UserTournamentDetail.is_anon_user?(anon.player_id) == true)
  end

  test "is_anon_user? should refute user_tournament_detail when real user", context do
    user = Helpers.create_user("notanon")
    player_id = User.player_id(user)
    utd =  Helpers.create_user_tournament_detail(player_id, user.username, context.tournament_id)
    refute(UserTournamentDetail.is_anon_user?(utd.player_id) == true)
  end

  test "is_anon_user? other cases" do
    refute(UserTournamentDetail.is_anon_user?("user|anon") == true)
    assert(UserTournamentDetail.is_anon_user?("anon|user") == true)
  end

end
