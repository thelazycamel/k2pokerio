defmodule K2pokerIo.CreateAnonUserTest do

  use K2pokerIo.ModelCase

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.User.CreateAnonUser

  doctest K2pokerIo.Commands.User.CreateAnonUser

  setup do
    Helpers.create_tournament()
    {:ok, anon_user} = CreateAnonUser.execute("stu")
    %{anon_user: anon_user}
  end

  test "#create anon user with nil will return anon" do
    {:ok, utd} = CreateAnonUser.execute(nil)
    assert utd.username == "anon"
  end

  test "#create anon user with empty string will return anon" do
    {:ok, utd} = CreateAnonUser.execute("")
    assert utd.username == "anon"
  end

  test "#create should create a new anon_user user_tournament_detal with default tournament", context do
    anon_user = context.anon_user
    default_tournament_id = K2pokerIo.Tournament.default.id
    assert(anon_user.tournament_id == default_tournament_id)
  end

  test "#create should create a username", context do
    anon_user = context.anon_user
    assert(anon_user.username == "stu")
  end

  test "#create should create a player_id", context do
    anon_user = context.anon_user
    [pre_name, random_hash] = String.split(anon_user.player_id, "|")
    assert(pre_name == "anon")
    assert(String.match?(random_hash, ~r/^stu/))
  end

  test "#create should set the current_score to 1", context do
    anon_user = context.anon_user
    assert(anon_user.current_score == 1)
  end

  test "#create should set the rebuys to [0]", context do
    anon_user = context.anon_user
    assert(anon_user.rebuys == [0])
  end

end
