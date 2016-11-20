defmodule K2pokerIo.Fixtures.GameFixture do

  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.Game.JoinCommand

  def create(user_tournament_detail) do
    JoinCommand.execute(user_tournament_detail)
  end

end
