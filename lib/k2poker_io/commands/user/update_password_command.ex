defmodule K2pokerIo.Commands.User.UpdatePasswordCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.User

  import Ecto.Changeset, only: [put_change: 3]

  def execute(current_user, passwords) do
    if confirm_current_password?(current_user, passwords) do
      if new_passwords_match?(passwords) do
        case update_password(current_user, passwords["new-password"]) do
          {:ok, changeset} -> {:ok}
          {:error, changeset} -> {:error, "error_password_length"}
        end
      else
        {:error, "error_password_mismatch"}
      end
    else
      {:error, "error_invalid_password"}
    end
  end

  defp confirm_current_password?(current_user, passwords) do
    case current_user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(passwords["current-password"], current_user.crypted_password)
    end
  end

  defp new_passwords_match?(passwords) do
    passwords["new-password"] == passwords["confirm-password"]
  end

  defp update_password(current_user, password) do
    User.changeset(current_user, %{password: password})
    |> put_change(:crypted_password, hashed_password(password))
    |> Repo.update()
  end

  defp hashed_password(password) do
    Comeonin.Bcrypt.hashpwsalt(password)
  end

end
