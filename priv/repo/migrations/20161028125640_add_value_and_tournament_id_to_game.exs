defmodule K2pokerIo.Repo.Migrations.AddValueAndTournamentIdToGame do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :tournament_id, references(:tournaments, on_delete: :delete_all)
      add :value, :integer
    end
  end

end
