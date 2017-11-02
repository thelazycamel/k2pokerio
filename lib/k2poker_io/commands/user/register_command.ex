defmodule K2pokerIo.Commands.User.RegisterCommand do

  import Ecto.Changeset, only: [put_change: 3]
  alias K2pokerIo.Repo

  def create(changeset) do
    changeset
    |> put_change(:crypted_password, hashed_password(changeset.params["password"]))
    |> Repo.insert()
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

end
