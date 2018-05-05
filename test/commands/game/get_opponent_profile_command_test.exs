defmodule K2pokerIo.GetOpponentProfileCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Game.GetOpponentProfileCommand

  use K2pokerIoWeb.ConnCase

  doctest K2pokerIo.Commands.Game.GetOpponentProfileCommand

  test "gets the opponents users profile given the current user" do
    setup = Helpers.advanced_set_up(["stu", "bob"])
    changeset = User.profile_changeset(setup.player2, %{blurb: "Hello from your opponent", image: "/images/profile-images/bob.png"})
    Repo.update(changeset)

    opponent = GetOpponentProfileCommand.execute(setup.game, setup.p1_utd.player_id)
    assert(opponent.id == setup.player2.id)
    assert(opponent.username == "bob")
    assert(opponent.opponent == :user)
    assert(opponent.blurb == "Hello from your opponent")
    assert(opponent.image == "/images/profile-images/bob.png")
    assert(opponent.friend == :not_friends)
  end

  test "returns an anonamous user profile" do
    setup = Helpers.basic_set_up(["stu", "bob"])
    opponent = GetOpponentProfileCommand.execute(setup.game, setup.player1.player_id)
    assert(opponent.id == nil)
    assert(opponent.username == "bob")
    assert(opponent.opponent == :anon)
    assert(opponent.blurb == "Meh, just an anonymous fish")
    assert(opponent.image == "/images/profile-images/fish.png")
    assert(opponent.friend == :na)
  end

  test "returns a BOT profile" do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("stu")
    utd = Helpers.create_user_tournament_detail(User.player_id(player), player.username, tournament.id)
    {:ok, game} = Helpers.join_game(utd)
    game_changeset = K2pokerIo.Game.join_changeset(game, %{player2_id: "BOT", waiting_for_players: false})
    game = Repo.update!(game_changeset)
    opponent = GetOpponentProfileCommand.execute(game, User.player_id(player))
    assert(opponent.id == nil)
    assert(opponent.username == "RandomBot")
    assert(opponent.opponent == :bot)
    assert(opponent.blurb == "Blackmail is such an ugly word. I prefer extortion. The ‘x’ makes it sound cool.")
    assert(opponent.image == "/images/profile-images/bender.png")
    assert(opponent.friend == :na)
  end

  test "returns an empty profile" do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("stu")
    utd = Helpers.create_user_tournament_detail(User.player_id(player), player.username, tournament.id)
    {:ok, game} = Helpers.join_game(utd)
    opponent = GetOpponentProfileCommand.execute(game, User.player_id(player))
    assert(Enum.count(Map.to_list(opponent)) == 0)
  end

end
