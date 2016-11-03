defmodule K2pokerIo.LayoutView do
  use K2pokerIo.Web, :view

  def body_classes(conn) do
    "#{get_controller(conn)} #{get_action(conn)}"
  end

  def body_page_data(conn) do
    "#{get_controller(conn)}-#{get_action(conn)}"
  end

  def user_token(player_id) do
    cond do
      player_id == "" -> ""
      true -> Phoenix.Token.sign(K2pokerIo.Endpoint, "player_id", player_id)
    end
  end

  defp get_controller(conn) do
    [_exp, controller] = Regex.run(~r/\.(\w+)Controller/, "#{conn.private.phoenix_controller}")
    String.downcase(controller)
  end

  defp get_action(conn) do
    Atom.to_string(conn.private.phoenix_action)
  end

end
