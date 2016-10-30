defmodule K2pokerIo.Repo.Migrations.CreateUserTournamentDetail do
  use Ecto.Migration

  def change do

    create table(:user_tournament_details) do

      add :player_id, :string
      add :username, :string
      add :tournament_id, references(:tournaments, on_delete: :nothing)
      add :game_id, references(:games, on_delete: :nothing)
      add :current_score, :integer
      add :rebuys, {:array, :integer}

      timestamps

    end

  end
end
