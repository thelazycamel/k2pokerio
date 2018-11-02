defmodule K2pokerIo.Repo.Migrations.DefaultTournament do
  use Ecto.Migration

  def change do
    Repo.insert!(%Tournament{
      name: "K2 Summit",
      description: "K2 Summit is the big one, play against everyone in this free and open tournament, always available."
      default_tournament: true,
      private: false,
      finished: false,
      bots: true,
      type: "tournament"
    })
  end
end
