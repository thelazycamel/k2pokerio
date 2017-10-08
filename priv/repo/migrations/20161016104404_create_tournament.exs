defmodule K2pokerIo.Repo.Migrations.CreateTournament do
  use Ecto.Migration

  def change do

    create table(:tournaments) do

      add :name, :string
      add :default_tournament, :boolean, default: false
      add :finished, :boolean, default: false
      add :top_player, :string
      add :private, :boolean, default: true
      add :player_id, :string
      add :rebuys, :binary
      add :start_time, :datetime
      add :player_ids, {:array, :string}

      timestamps()

    end

  end
end
