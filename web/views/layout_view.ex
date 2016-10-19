defmodule K2pokerIo.LayoutView do
  use K2pokerIo.Web, :view

  def user_token(player_id) do
    cond do
      player_id == "" -> ""
      true -> Phoenix.Token.sign(K2pokerIo.Endpoint, "player_id", player_id)
    end
  end

end
