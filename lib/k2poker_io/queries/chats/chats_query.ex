defmodule K2pokerIo.Queries.Chats.ChatsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Chat

  import Ecto.Query

  def count(current_user_id) do
    Repo.one(from c in Chat, select: count(c.id), where: [user_id: ^current_user_id])
  end

end
