defmodule K2pokerIo.Repo.Migrations.AddProfileToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :image, :string
      add :blurb, :string
    end

  end
end
