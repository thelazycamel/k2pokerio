defmodule K2pokerIoWeb.ChatChannel do

  use K2pokerIoWeb, :channel

  alias K2pokerIo.Chat
  alias K2pokerIoWeb.Commands.Chat.CreateCommentCommand

  def join("chat:" <> tournament_id, _params, socket) do
    username = case socket.assigns[:current_user] do
      nil -> nil
      _ -> socket.assigns[:current_user].username
    end
    send self(), {:after_join, tournament_id: tournament_id, username: username}
    {:ok, socket}
  end

  def handle_in("chat:create_comment", %{"comment" => comment, "tournament_id" => tournament_id}, socket) do
    if current_user = socket.assigns[:current_user] do
      {tournament_id, _} = Integer.parse(tournament_id)
      case CreateCommentCommand.execute(%{user_id: current_user.id, tournament_id: tournament_id, comment: comment, admin: false}) do
        {:ok, chat} ->
          broadcast! socket, "chat:new_comment", %{id: chat.id, username: current_user.username, comment: chat.comment, admin: chat.admin}
        {:error, _} ->
          :error
      end
    end
    {:noreply, socket}
  end

  def handle_info({:after_join, tournament_id: tournament_id, username: username}, socket) do
    {tournament_id, _} = Integer.parse(tournament_id)
    comments = Chat.get_ten_json(tournament_id)
    if username do
      dom_id = :rand.uniform(100000000)
      broadcast! socket, "chat:new_comment", %{username: username, comment: "has joined the tournament", admin: true, id: "admin-#{dom_id}"}
    end
    push socket, "chat:new_list", %{comments: comments}
    {:noreply, socket}
  end

end
