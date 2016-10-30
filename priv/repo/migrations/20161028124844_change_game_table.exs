defmodule K2pokerIo.Repo.Migrations.ChangeGameTable do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :waiting_for_players, :boolean, default: true
      remove :player1
      remove :player2
      remove :status
    end
  end

end
