defmodule K2pokerIo.Repo.Migrations.AddUserIdToUserTournamentDetails do
  use Ecto.Migration

  def change do
    alter table(:user_tournament_details) do
      add :user_id, :integer
    end
  end
end
