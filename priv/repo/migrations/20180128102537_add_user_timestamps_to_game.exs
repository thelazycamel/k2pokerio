defmodule K2pokerIo.Repo.Migrations.AddUserTimestampsToGame do
  use Ecto.Migration

  def change do
    alter table(:games) do
      add :p1_timestamp, :utc_datetime
      add :p2_timestamp, :utc_datetime
    end
  end

end
