defmodule K2pokerIo.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:chats) do

      add :user_id, references(:users, on_delete: :delete_all)
      add :tournament_id, references(:tournaments, on_delete: :delete_all)
      add :comment, :string
      add :admin, :boolean, default: false

      timestamps()

    end
  end

end
