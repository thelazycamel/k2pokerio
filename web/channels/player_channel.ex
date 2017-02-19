defmodule K2pokerIo.PlayerChannel do
  use K2pokerIo.Web, :channel
  alias K2pokerIo.UserTournamentDetail

  def join("player:" <> player_token, _params, socket) do
    case Phoenix.Token.verify(K2pokerIo.Endpoint, "player_id", player_token, max_age: 86400000) do
      {:ok,  player_id} ->
        cond do
          player_id == "" -> :error
          player_id == nil -> :error
          player_id == socket.assigns[:player_id] ->
            {:ok, socket}
          true -> :error
        end
    end
  end

  def handle_in("player:get_current_score", _params, socket) do
    count = socket.assigns[:count] || 1
    utd = Repo.get_by(UserTournamentDetail, player_id: socket.assigns[:player_id])
    push socket, "player:updated_score", %{current_score: utd.current_score}
    {:noreply, socket}
  end

end
