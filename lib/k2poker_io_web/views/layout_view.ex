defmodule K2pokerIoWeb.LayoutView do

  use K2pokerIoWeb, :view

  def body_classes(conn) do
    "#{get_controller(conn)} #{get_action(conn)}"
  end

  def body_data(conn) do
    Enum.map(data_for_app(conn), fn ({k,v}) -> "data-#{k}=#{v}" end)
    |> Enum.join(" ")
  end

  #TODO move this to a json call, probably logged_in and page can stay (why do i record page here?)
  # but definately tournament_id and bots should be called via service api, we can collect any other info there too.
  #
  def data_for_app(conn) do
    [
      page: "#{get_controller(conn)}#{String.capitalize(get_action(conn))}",
      tournament_id: conn.assigns[:tournament_id],
      logged_in: conn.assigns[:logged_in],
      chat_disabled: conn.assigns[:chat_disabled],
      locale: "en",  #TODO set a ISO locale (from the request) in the conn to be picked up here
      bots: conn.assigns[:bots] || false,
      tournament_type: conn.assigns[:tournament_type]
    ]
  end

  def user_token(player_id) do
    cond do
      player_id == "" -> ""
      true -> Phoenix.Token.sign(K2pokerIoWeb.Endpoint, "player_id", player_id)
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
