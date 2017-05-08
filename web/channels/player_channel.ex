defmodule K2pokerIo.PlayerChannel do
  use K2pokerIo.Web, :channel
  alias K2pokerIo.UserTournamentDetail

  def join("player:" <> player_token, _params, socket) do
    #TODO consider passing the tournament_id here and assigning it to the socket,
    # we need to collect the players current score (for the tournament they are in) and
    # i have to keep passing the tournament id down the line
    # might need to consider removing this as a websocket and just have a standard rest
    # call to get the current score if we dont use this channel for anything else
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

  def handle_in("player:get_current_score", %{"tournament_id" => tournament_id}, socket) do
    {tournament_id, _} = Integer.parse(tournament_id)
    utd = Repo.get_by(UserTournamentDetail, player_id: socket.assigns[:player_id], tournament_id: tournament_id)
    push socket, "player:updated_score", %{current_score: utd.current_score, username: utd.username}
    {:noreply, socket}
  end

end
