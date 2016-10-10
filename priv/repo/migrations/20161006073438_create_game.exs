defmodule K2pokerIo.Repo.Migrations.CreateGame do
  use Ecto.Migration

  def change do

    create table(:games) do

      add :player1, :string
      add :player2, :string
      add :status, :string
      add :data, :binary

      timestamps

    end

  end

end
