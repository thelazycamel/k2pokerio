defmodule K2pokerIo.Repo.Migrations.UserBadges do
  use Ecto.Migration

  def change do
    create table(:user_badges) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :badge_id, references(:badges, on_delete: :delete_all)
      timestamps()
    end
  end
end
