defmodule K2pokerIo.Session do

  alias K2pokerIo.User

  def login(params, repo) do
    user = repo.get_by(User, email: String.downcase(params["email"]))
    case authenticate(user, params["password"]) do
      true -> {:ok, user}
      _    -> :error
    end
  end

  defp authenticate(user, password) do
    case user do
      nil -> false
      _   -> Comeonin.Bcrypt.checkpw(password, user.crypted_password)
    end
  end

  def current_user(conn) do
    if raw_player_id = Plug.Conn.get_session(conn, :player_id) do
      cond do
        String.match?(raw_player_id, ~r/^user/) ->
          id = List.last(String.split(raw_player_id, "-"))
          if id, do: K2pokerIo.Repo.get(User, id)
        true -> false
      end
    end
  end

  def logged_in?(conn), do: !!current_user(conn)

end
