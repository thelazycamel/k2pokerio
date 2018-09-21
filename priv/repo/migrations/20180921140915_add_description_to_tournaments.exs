defmodule K2pokerIo.Repo.Migrations.AddDescriptionToTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :description, :string
    end
  end

end
