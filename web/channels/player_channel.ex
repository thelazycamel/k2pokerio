# PLAYER CHANNEL DEALS WITH PASSING THE PLAYERS GAME DATA
# so only the actual player can subscribe to it,
# from the browser the user_token is passed, not the player id
# so we decode that first into the player_id and match it to the session player_id

defmodule K2pokerIo.PlayerChannel do
  use K2pokerIo.Web, :channel
  alias K2pokerIo.Game
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.PlayGameCommand

  def join("player:" <> token, _params, socket) do
    case Phoenix.Token.verify(K2pokerIo.Endpoint, "player_id", token, max_age: 86400000) do
      {:ok, player_id} ->
        cond do
          player_id == socket.assigns[:player_id] ->
            utd = Repo.get_by(UserTournamentDetail, player_id: player_id) |> Repo.preload(:game)
            decoded_game = Game.decode_game_data(utd.game.data)
            payload = Game.player_data(decoded_game, player_id)
            {:ok, payload, socket}
          true -> :error
        end
      {:error, _} -> :error
    end
  end

  #TODO write tests and handle errors
  #
  def handle_in("player:play", _params, socket) do
    player_id = socket.assigns[:player_id]
    utd = Repo.get_by(UserTournamentDetail, player_id: player_id)
    payload = PlayGameCommand.execute(utd.game_id, player_id)
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("player:get_fresh_data", _params, socket) do
    player_id = socket.assigns[:player_id]
    utd = Repo.get_by(UserTournamentDetail, player_id: player_id)
    payload = GetGameDataCommand.execute(utd.game_id, player_id)
    {:reply, {:ok, payload}, socket}
  end

end
