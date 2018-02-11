defmodule K2pokerIo.Repo.Migrations.AddTypeToTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :type, :string
    end
  end

end
