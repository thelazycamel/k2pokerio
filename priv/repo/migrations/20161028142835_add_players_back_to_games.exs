defmodule K2pokerIo.Repo.Migrations.AddPlayersBackToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :player1_id, :string
      add :player2_id, :string
    end
  end
end
