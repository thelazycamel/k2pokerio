defmodule K2pokerIo.Commands.Chat.CreateCommentCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Chat
  alias K2pokerIo.Queries.Chats.ChatsQuery
  alias K2pokerIo.Commands.Badges.UpdateMiscBadgesCommand

  import Ecto.Query

  use PhoenixHtmlSanitizer, :strip_tags

  def execute(params) do
    sanatize_comment(params)
    |> create_comment()
  end

  defp sanatize_comment(params) do
    {:safe, sanatized_comment} = sanitize(params.comment, :strip_tags)
    %{
      user_id: params.user_id,
      tournament_id: params.tournament_id,
      admin: params.admin,
      comment: sanatized_comment
    }
  end

  defp create_comment(params) do
    changeset = Chat.changeset(%Chat{},params)
    check_badge(params[:user_id], params[:tournament_id])
    Repo.insert(changeset)
  end

  # Note: this is run just before creating the new chat so check that 4 have already been created
  defp check_badge(user_id, tournament_id) do
    if ChatsQuery.count(user_id) == 4 do
      UpdateMiscBadgesCommand.execute("5_chats", "user|#{user_id}", %{broadcast: "chat", id: tournament_id})
    end
  end

end
