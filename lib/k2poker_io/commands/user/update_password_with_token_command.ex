defmodule K2pokerIo.Commands.User.UpdatePasswordWithTokenCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Commands.User.GetUserFromTokenCommand

  import Ecto.Changeset, only: [put_change: 3]

  def execute(token, password, password_confirmation) do
    case GetUserFromTokenCommand.execute(token) do
      {:ok, user} ->
        if password == password_confirmation do
          case update_password(user, password) do
            {:ok, new_user} -> {:ok, new_user}
            {:error, _} -> {:error, "Password too short"}
          end
        else
          {:error, "Passwords do not match"}
        end
      {:error, message} -> {:error, message}
    end
  end

  defp update_password(user, password) do
    data = Map.delete(user.data, "token")
    |> Map.delete("token_expiry_time")
    User.changeset(user, %{password: password, data: data})
    |> put_change(:crypted_password, hashed_password(password))
    |> Repo.update()
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

end
