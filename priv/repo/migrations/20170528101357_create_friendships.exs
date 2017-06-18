defmodule K2pokerIo.Repo.Migrations.CreateFriendships do
  use Ecto.Migration

  def change do
    create table(:friendships) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :friend_id, references(:users, on_delete: :delete_all)
      add :status, :boolean

      timestamps()
    end

  end
end
