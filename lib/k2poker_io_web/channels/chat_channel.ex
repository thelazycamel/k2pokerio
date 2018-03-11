defmodule K2pokerIoWeb.ChatChannel do

  use K2pokerIoWeb, :channel

  alias K2pokerIo.Chat
  alias K2pokerIo.Repo
  alias K2pokerIo.Commands.Chat.CreateCommentCommand

  intercept ["chat:new_comment"]

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
          broadcast! socket, "chat:new_comment", %{"chat_id" => chat.id}
        {:error, _} ->
          :error
      end
    end
    {:noreply, socket}
  end

  def handle_out("chat:new_comment", %{"chat_id" => chat_id}, socket) do
    player_id = socket.assigns[:player_id]
    comment = Repo.get_by(Chat, id: chat_id) |> Repo.preload(:user)
    push socket, "chat:new_comment", K2pokerIo.Decorators.CommentDecorator.decorate(comment, player_id)
    {:noreply, socket}
  end

  def handle_info({:after_join, tournament_id: tournament_id, username: username}, socket) do
    {tournament_id, _} = Integer.parse(tournament_id)
    player_id = socket.assigns[:player_id]
    comments = Chat.get_ten_json(tournament_id, player_id)
    push socket, "chat:new_list", %{comments: comments}
    {:noreply, socket}
  end

end
