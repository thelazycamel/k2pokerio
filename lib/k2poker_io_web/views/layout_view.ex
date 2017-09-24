defmodule K2pokerIoWeb.LayoutView do

  use K2pokerIoWeb, :view

  def body_classes(conn) do
    "#{get_controller(conn)} #{get_action(conn)}"
  end

  def body_data(conn) do
    Enum.map(data_for_app(conn), fn ({k,v}) -> "data-#{k}=#{v}" end)
    |> Enum.join(" ")
  end

  def data_for_app(conn) do
    [
      page: "#{get_controller(conn)}#{String.capitalize(get_action(conn))}",
      tournament_id: conn.assigns[:tournament_id],
      logged_in: conn.assigns[:logged_in],
      bots: conn.assigns[:bots]
    ]
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
