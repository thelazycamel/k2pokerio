defmodule K2pokerIo.Commands.User.RequestNewPasswordCommand do

  alias K2pokerIo.User
  alias K2pokerIo.Repo
  import Ecto.Query

  def execute(email) do
    if user = get_user(email) do
      user
      |> create_expiring_token
      |> send_forgotten_password_email
    else
      {:error, "Email does not exist"}
    end
  end

  defp get_user(email) do
    Repo.one(from u in User, where: u.email == ^email)
  end

  defp create_expiring_token(user) do
    data = Map.merge(user.data, %{"token" => token(), "token_expiry_time" => token_expiry_time()})
    Repo.update!(User.changeset(user, %{data: data}))
  end

  defp send_forgotten_password_email(user) do
    unless Application.get_env(:k2poker_io, :env) == :test do
      K2pokerIoWeb.UserAccount.forgotten_password(user.email, user.data["token"])
      |> K2pokerIoWeb.Mailer.deliver_now
    end
    {:ok, user}
  end

  defp token do
    :crypto.strong_rand_bytes(42) |> Base.url_encode64 |> binary_part(0, 42)
  end

  defp token_expiry_time do
    Timex.now |> Timex.shift(hours: 4)
  end

end
