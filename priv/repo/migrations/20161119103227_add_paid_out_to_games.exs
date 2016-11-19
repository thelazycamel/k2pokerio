defmodule K2pokerIo.Repo.Migrations.AddPaidOutToGames do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :p1_paid, :boolean, default: false
      add :p2_paid, :boolean, default: false
    end

  end

end
