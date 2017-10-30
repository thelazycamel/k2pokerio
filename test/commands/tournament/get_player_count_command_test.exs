defmodule K2pokerIo.GetPlayerCountCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Commands.Tournament.GetPlayerCountCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.GetPlayerCountCommand

  setup do
    Helpers.basic_advanced_up(["bob", "stu"])
  end

end
