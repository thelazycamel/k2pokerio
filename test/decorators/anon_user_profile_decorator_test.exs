defmodule K2pokerIo.AnonUserProfileDecoratorTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Decorators.AnonUserProfileDecorator

  use K2pokerIoWeb.ConnCase

  doctest K2pokerIo.Decorators.AnonUserProfileDecorator

  setup do
    tournament = Helpers.create_tournament()
    utd = Helpers.create_user_tournament_detail("stu", tournament.id)
    %{decorator: AnonUserProfileDecorator.decorate(utd.player_id)}
  end

  test "should not have a player_id", context do
    assert(context.decorator.id == nil)
  end

  test "should have a username", context do
    assert(context.decorator.username == "stu")
  end

  test "should have an opponent type", context do
    assert(context.decorator.opponent == :anon)
  end

  test "should have a blurb", context do
    assert(context.decorator.blurb == "Meh, just an anonymous fish")
  end

  test "should have an image", context do
    assert(context.decorator.image == "fish.png")
  end

  test "should have a friend status", context do
    assert(context.decorator.friend == :na)
  end

end
