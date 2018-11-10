defmodule K2pokerIo.Repo.Migrations.CreateUserStats do
  use Ecto.Migration

  def change do
    create table(:user_stats) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :games_played,    :integer, default: 0
      add :games_won,       :integer, default: 0
      add :games_lost,      :integer, default: 0
      add :games_folded,    :integer, default: 0
      add :tournaments_won, :integer, default: 0
      add :duels_won,       :integer, default: 0
      add :top_score,       :integer, default: 0
      timestamps()
    end
  end
end
