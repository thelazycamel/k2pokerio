defmodule K2pokerIo.UserSocket do
  use Phoenix.Socket

  ## Channels
  channel "tournament:*", K2pokerIo.TournamentChannel

  ## Transports
  transport :websocket, Phoenix.Transports.WebSocket
  # transport :longpoll, Phoenix.Transports.LongPoll

  # Socket params are passed from the client and can
  # be used to verify and authenticate a user. After
  # verification, you can put default assigns into
  # the socket that will be set for all channels, ie
  #
  #     {:ok, assign(socket, :user_id, verified_user_id)}
  #
  # To deny connection, return `:error`.
  #
  # See `Phoenix.Token` documentation for examples in
  # performing token verification on connect.
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(socket, "player_id", token, max_age: 86400000) do
      {ok, user_id} ->
        cond do
          user_id == "" -> :error
          # First check to see if the user token is an anonomous user and just return ok
          # with the player_id passed back
          String.match?(user_id, ~r/^anon/) ->
            socket = assign(socket, :player_id, user_id)
            {:ok, socket}
          # then check if user_id is a db user
          #TODO match a user_id to a db user and return its user_id to :player_id
          # user = Repo.get!(User, user_id)
          true -> :error
        end
      {:error, _} ->
        :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     K2pokerIo.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
