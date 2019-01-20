defmodule K2pokerIo.Commands.Chat.BroadcastTournamentMessageCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Chat

  def execute(tournament_id, comment, username) do
    create_payload(tournament_id, comment, username)
    |> broadcast_to_tournament(tournament_id)
  end

  defp create_payload(tournament_id, comment, username) do
    chat_id = "admin-#{:rand.uniform(100000000)}"
    %{username: username, comment: comment, admin: true, chat_id: chat_id}
  end

  defp broadcast_to_tournament(payload, tournament_id) do
    K2pokerIoWeb.Endpoint.broadcast!("chat:#{tournament_id}", "chat:admin_message", payload)
  end

end
