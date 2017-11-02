defmodule K2pokerIoWeb.Helpers.Session do

  alias K2pokerIo.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def current_user(conn) do
    if player_id = Plug.Conn.get_session(conn, :player_id) do
      {type, user_id} = User.get_id(player_id)
      cond do
        type == :user -> K2pokerIo.Repo.get(User, user_id)
        true -> false
      end
    end
  end

  def logged_in?(conn), do: !!current_user(conn)

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

end
