defmodule K2pokerIo.Commands.User.GetUserFromTokenCommand do

  alias K2pokerIo.User
  alias K2pokerIo.Repo
  import Ecto.Query

  def execute(token) do
    find_user_from_token(token)
    |> check_validity
  end

  defp find_user_from_token(token) do
    Repo.one(
      from u in User,
      where: fragment("(data->'token')::jsonb \\? ?", ^token)
    )
  end

  defp check_validity(user) do
    if user do
      check_expiry(user)
    else
      {:error, "No user found"}
    end
  end

  defp check_expiry(user) do
    token_expiry_time = Timex.parse!(user.data["token_expiry_time"], "{ISO:Extended}")
    if Timex.before?(Timex.now, token_expiry_time) do
      {:ok, user}
    else
      {:error, "Token expired"}
    end
  end

end
