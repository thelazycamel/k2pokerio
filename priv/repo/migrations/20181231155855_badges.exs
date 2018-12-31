defmodule K2pokerIo.Repo.Migrations.Badges do
  use Ecto.Migration

  def change do
    create table(:badges) do
      add :name, :string
      add :description, :string
      add :action, :string
      add :image, :string
      add :group, :integer
      add :position, :integer
      add :gold, :boolean
      timestamps()
    end
  end

end
