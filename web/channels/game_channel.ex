defmodule K2pokerIo.GameChannel do
  use K2pokerIo.Web, :channel

  def join("game:" <> game_id, _params, socket) do
    require IEx; IEx.pry
    {:ok, socket}
  end

end
