defmodule K2pokerIo.Repo.Migrations.AmendTournaments do
  use Ecto.Migration

  def change do
    alter table(:tournaments) do
      remove :player_id
      remove :player_ids
      remove :top_player
      add :user_id, references(:users, on_delete: :nothing)
      add :lose_type, :string, default: "all"
      add :starting_chips, :integer, default: 1
      add :max_score, :integer, default: 1048576
      add :bots, :boolean
    end
  end
end
