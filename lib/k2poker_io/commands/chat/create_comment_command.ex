defmodule K2pokerIo.Commands.Chat.CreateCommentCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Chat

  def execute(params) do
    if params.user_id && params.tournament_id && params.comment do
      create_comment(params)
    else
      {:error, "invalid details"}
    end
  end

  def create_comment(params) do
    changeset = Chat.changeset(%Chat{},params)
    Repo.insert(changeset)
  end

end
