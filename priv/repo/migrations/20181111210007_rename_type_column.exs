defmodule K2pokerIo.Repo.Migrations.RenameTypeColumn do
  use Ecto.Migration

  def change do
    rename table(:tournaments), :type, to: :tournament_type
  end

end
