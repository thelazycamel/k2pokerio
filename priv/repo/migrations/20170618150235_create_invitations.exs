defmodule K2pokerIo.Repo.Migrations.CreateInvitations do
  use Ecto.Migration

  def change do
    create table(:invitations) do
      add :user_id, references(:users, on_delete: :delete_all)
      add :tournament_id, references(:tournaments, on_delete: :delete_all)
      add :accepted, :boolean
      timestamps()
    end
  end

end
