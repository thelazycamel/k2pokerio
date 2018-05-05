defmodule K2pokerIo.UserProfileDecoratorTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Decorators.UserProfileDecorator

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Decorators.UserProfileDecorator

  setup do
    setup = Helpers.advanced_set_up(["stu", "bob"])
    changeset = User.profile_changeset(setup.player2, %{blurb: "Hello from your opponent", image: "/images/profile-images/bob.png"})
    Repo.update(changeset)
    decorator = UserProfileDecorator.decorate(User.player_id(setup.player1), setup.player2.id)
    %{player1: setup.player1, player2: setup.player2, decorator: decorator}
  end

  test "should have a player_id", context do
    assert(context.decorator.id == context.player2.id)
  end

  test "should have a username", context do
    assert(context.decorator.username == "bob")
  end

  test "should have an opponent type", context do
    assert(context.decorator.opponent == :user)
  end

  test "should have a blurb", context do
    assert(context.decorator.blurb == "Hello from your opponent")
  end

  test "should have an image", context do
    assert(context.decorator.image == "/images/profile-images/bob.png")
  end

  test "should have a friend status", context do
    assert(context.decorator.friend == :not_friends)
  end

end
