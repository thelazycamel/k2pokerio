defmodule K2pokerIoWeb.UserSocket do

  use Phoenix.Socket

  alias K2pokerIo.Repo
  alias K2pokerIo.User

  ## Channels
  channel "tournament:*", K2pokerIoWeb.TournamentChannel
  channel "game:*", K2pokerIoWeb.GameChannel
  channel "chat:*", K2pokerIoWeb.ChatChannel

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
  # dont forget to pass the player_id though the controller to connect to channels
  # it is picked up in the app layout and converted to a token in the layout_view
  #
  def connect(%{"token" => token}, socket) do
    case Phoenix.Token.verify(K2pokerIoWeb.Endpoint, "player_id", token, max_age: 86400000) do
      {:ok, player_id} ->
        {type, user_id} = User.get_id(player_id)
        cond do
          type == :error -> :error
          type == :anon ->
            socket = assign(socket, :player_id, player_id)
            {:ok, socket}
          type == :user ->
            socket = assign(socket, :player_id, player_id)
             |> assign(:current_user, Repo.get(User, user_id))
            {:ok, socket}
          true ->
            :error
        end
      {:error, _} -> :error
    end
  end

  # Socket id's are topics that allow you to identify all sockets for a given user:
  #
  #     def id(socket), do: "users_socket:#{socket.assigns.user_id}"
  #
  # Would allow you to broadcast a "disconnect" event and terminate
  # all active sockets and channels for a given user:
  #
  #     K2pokerIoWeb.Endpoint.broadcast("users_socket:#{user.id}", "disconnect", %{})
  #
  # Returning `nil` makes this socket anonymous.
  def id(_socket), do: nil
end
