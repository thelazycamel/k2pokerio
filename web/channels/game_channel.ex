defmodule K2pokerIo.GameChannel do
  use K2pokerIo.Web, :channel
  alias K2pokerIo.Game
  alias K2pokerIo.Commands.Game.PlayCommand
  alias K2pokerIo.Commands.Game.DiscardCommand
  alias K2pokerIo.Commands.Game.FoldCommand
  alias K2pokerIo.Commands.Game.JoinCommand
  alias K2pokerIo.Commands.Game.GetDataCommand
  alias K2pokerIo.UserTournamentDetail

  intercept ["game:new_game_data", "game:new_game"]

  def join("game:" <> game_id, _params, socket) do
    player_id = socket.assigns[:player_id]
    game = Repo.get!(Game, game_id)
    if game && Enum.member?([game.player1_id, game.player2_id], player_id) do
      {:ok, socket}
    else
      :error
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

  def handle_in("game:discard", %{"card_index" => card_index}, socket) do
    player_id = socket.assigns[:player_id]
    {card_index, _} = Integer.parse(card_index)
    {:reply, :ok, socket}
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
    {:reply, :ok, socket}
    case FoldCommand.execute(get_game_id(socket), player_id) do
      {:ok, _} ->
        broadcast! socket, "game:new_game_data", %{}
        {:reply, :ok, socket}
        :error ->
          :error
    end
  end

  def handle_in("game:next_game", _params, socket) do
    player_id = socket.assigns[:player_id]
    if utd = Repo.get_by(UserTournamentDetail, player_id: player_id) |> Repo.preload(:game) do
       case JoinCommand.execute(utd) do
        {:ok, game} -> broadcast! socket, "game:new_game", %{game_id: game.id, player_id: player_id}
        _ -> nil
      end
    end
    {:reply, :ok, socket}
  end

  def handle_out("game:new_game", %{game_id: game_id, player_id: player_id}, socket) do
    if player_id == socket.assigns[:player_id] do
      push socket, "game:new_game", %{game_id: game_id}
    end
    {:noreply, socket}
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