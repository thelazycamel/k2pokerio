defmodule K2pokerIo.Repo.Migrations.CreateDefaultTournament do
  use Ecto.Migration

  def change do
    changeset = %K2pokerIo.Tournament{ name: "The Big Kahuna", default_tournament: true, finished: false, private: false, lose_type: "all", starting_chips: 1, max_score: 1048576, bots: true, rebuys: [0] }
    K2pokerIo.Repo.insert(changeset)
  end
end
