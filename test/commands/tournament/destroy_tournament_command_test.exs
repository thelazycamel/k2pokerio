defmodule K2pokerIo.DestroyTournamentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Commands.Tournament.DestroyCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.CreateCommand

  setup do
    Helpers.basic_advanced_up(["bob", "stu"])
  end

end
