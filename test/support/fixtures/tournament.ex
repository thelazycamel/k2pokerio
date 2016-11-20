defmodule K2pokerIo.Fixtures.TournamentFixture do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament

  def create do
    Repo.insert!(%Tournament{name: "K2 Summit Ascent Test", default: true, private: false, finished: false})
  end

end
