defmodule K2pokerIo.Repo.Migrations.EnableCitext do

  use Ecto.Migration

  def up do
    execute "CREATE EXTENSION citext"
  end

  def down do
    execute "DROP EXTENSION citext"
  end

end
