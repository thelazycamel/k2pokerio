defmodule K2pokerIoWeb.GameChannel do

  use K2pokerIoWeb, :channel

  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail

  alias K2pokerIo.Commands.Game.PlayCommand
  alias K2pokerIo.Commands.Game.DiscardCommand
  alias K2pokerIo.Commands.Game.FoldCommand
  alias K2pokerIo.Commands.Game.JoinCommand
  alias K2pokerIo.Commands.Game.GetDataCommand
  alias K2pokerIo.Commands.Game.RequestBotCommand

  intercept ["game:new_game_data", "game:new_game"]

  def join("game:" <> game_id, _params, socket) do
    player_id = socket.assigns[:player_id]
    game = Repo.get!(Game, game_id)
    if game && Enum.member?([game.player1_id, game.player2_id], player_id) do
      {:ok, socket}
    else
      {:error, :error}
    end
  end

  def handle_in("game:refresh_data", _params, socket) do
    broadcast! socket, "game:new_game_data", %{}
    {:reply, :ok, socket}
  end

  def handle_in("game:play", _params, socket) do
    player_id = socket.assigns[:player_id]
    case PlayCommand.execute(get_game_id(socket), player_id) do
      {:ok, _} ->
        broadcast! socket, "game:new_game_data", %{}
        {:reply, :ok, socket}
      :error ->
        :error
    end
  end

  def handle_in("game:bot_request", _params, socket) do
    case RequestBotCommand.execute(get_game_id(socket)) do
      {:ok, _} ->
        broadcast! socket, "game:new_game_data", %{}
        {:reply, :ok, socket}
      {:error} ->
        :error
    end
  end

  def handle_in("game:discard", %{"card_index" => card_index}, socket) do
    player_id = socket.assigns[:player_id]
    {card_index, _} = Integer.parse(card_index)
    case DiscardCommand.execute(get_game_id(socket), player_id, card_index) do
      {:ok, _} ->
        broadcast! socket, "game:new_game_data", %{}
        {:reply, :ok, socket}
        :error ->
          :error
    end
  end

  def handle_in("game:fold", _params, socket) do
    player_id = socket.assigns[:player_id]
    case FoldCommand.execute(get_game_id(socket), player_id) do
      {:ok, _} ->
        broadcast! socket, "game:new_game_data", %{}
        {:reply, :ok, socket}
        :error ->
          :error
    end
  end

  def handle_out("game:new_game_data", _params, socket) do
    player_id = socket.assigns[:player_id]
    payload = GetDataCommand.execute(get_game_id(socket), player_id)
    push socket, "game:new_game_data", payload
    {:noreply, socket}
  end

  defp get_game_id(socket) do
    List.last(String.split(socket.topic, ":"))
  end

end
