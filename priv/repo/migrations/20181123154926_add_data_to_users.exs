defmodule K2pokerIo.Repo.Migrations.AddDataToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :data, :map, default: "{}"
    end
  end

end
