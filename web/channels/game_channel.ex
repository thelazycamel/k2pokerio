defmodule K2pokerIo.GameChannel do
  use K2pokerIo.Web, :channel
  alias K2pokerIo.Game

  def join("game:" <> game_id, _params, socket) do
    player_id = socket.assigns[:player_id]
    game = Repo.get!(Game, game_id)
    if game && Enum.member?([game.player1_id, game.player2_id], player_id) do
      {:ok, socket}
    else
      :error
    end
  end

  def handle_in("game:played", _params, socket) do
    broadcast_from(socket, "game:other_player_played", %{message: "request new data from the player channel"})
    {:reply, :ok, socket}
  end

end
