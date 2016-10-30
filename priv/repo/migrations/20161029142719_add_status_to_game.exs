defmodule K2pokerIo.Repo.Migrations.AddStatusToGame do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :open, :boolean, default: true
    end
  end

end
