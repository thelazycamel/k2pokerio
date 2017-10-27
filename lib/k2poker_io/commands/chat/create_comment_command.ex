defmodule K2pokerIo.Commands.Chat.CreateCommentCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Chat
  use PhoenixHtmlSanitizer, :strip_tags

  def execute(params) do
    sanatize_comment(params)
    |> create_comment()
  end

  # TODO not convinced this should be here, perhaps it should be actioned
  # in the model changeset

  defp sanatize_comment(params) do
    {:safe, sanatized_comment} = sanitize(params.comment, :strip_tags)
    %{
      user_id: params.user_id,
      tournament_id: params.tournament_id,
      comment: sanatized_comment
    }
  end

  defp create_comment(params) do
    changeset = Chat.changeset(%Chat{},params)
    Repo.insert(changeset)
  end

end
