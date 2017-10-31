defmodule K2pokerIo.JoinTournamentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Tournament
  alias K2pokerIo.Commands.Tournament.JoinTournamentCommand

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.JoinTournamentCommand

  setup do
    Helpers.basic_advanced_up(["bob", "stu"])
  end

end
