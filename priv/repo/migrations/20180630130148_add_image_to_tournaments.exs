defmodule K2pokerIo.Repo.Migrations.AddImageToTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      add :image, :string
    end
  end

end
