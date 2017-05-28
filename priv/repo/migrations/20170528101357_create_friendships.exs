defmodule K2pokerIo.Repo.Migrations.CreateFriendships do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :user_id, references(:users, on_delete: :nothing)
      add :friend_id, references(:users, on_delete: :nothing)
      add :status, :boolean

      timestamps()
    end

  end
end
