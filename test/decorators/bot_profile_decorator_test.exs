defmodule K2pokerIo.BotProfileDecoratorTest do

  alias K2pokerIo.Decorators.BotProfileDecorator

  use K2pokerIo.DataCase, async: false

  doctest K2pokerIo.Decorators.BotProfileDecorator

  setup do
    %{decorator:  BotProfileDecorator.decorate()}
  end

  test "should not have a player_id", context do
    assert(context.decorator.id == nil)
  end

  test "should have a username", context do
    assert(context.decorator.username == "DumbBot")
  end

  test "should have an opponent type", context do
    assert(context.decorator.opponent == :bot)
  end

  test "should have a blurb", context do
    assert(context.decorator.blurb =~ ~r/Blackmail is such an ugly word/)
  end

  test "should have an image", context do
    assert(context.decorator.image == "/images/profile-images/bot.png")
  end

  test "should have a friend status", context do
    assert(context.decorator.friend == :na)
  end

end
