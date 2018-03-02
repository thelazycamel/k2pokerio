defmodule K2pokerIo.Repo.Migrations.AddFoldToUserTournamentDetail do
  use Ecto.Migration

  def change do
    alter table(:user_tournament_details) do
      add :fold, :boolean, default: true
    end
  end

end
