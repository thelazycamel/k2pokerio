defmodule K2pokerIo.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do

    create table(:users) do
      add :email, :citext, null: false
      add :crypted_password, :string

      timestamps()
    end
    create unique_index(:users, [:email])

  end
end
