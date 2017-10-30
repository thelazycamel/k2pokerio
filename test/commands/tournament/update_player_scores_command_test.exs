defmodule K2pokerIo.UpdatePlayerScoreCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand

  setup do
    Helpers.basic_advanced_up(["bob", "stu"])
  end

end
