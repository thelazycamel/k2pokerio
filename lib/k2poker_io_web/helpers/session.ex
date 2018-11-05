defmodule K2pokerIoWeb.Helpers.Session do

  alias K2pokerIo.User
  alias K2pokerIo.Repo

  #TODO move login to a command

  def login(params) do
    user = Repo.get_by(User, email: params["email"]) || Repo.get_by(User, username: params["email"])
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  def current_user(conn) do
    if player_id = Plug.Conn.get_session(conn, :player_id) do
      {type, user_id} = User.get_id(player_id)
      cond do
        type == :user -> Repo.get(User, user_id)
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
