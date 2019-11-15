defmodule K2pokerIo.Queries.Chats.ChatsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Chat

  import Ecto.Query

  def count(current_user_id) do
    Repo.one(from c in Chat, select: count(c.id), where: [user_id: ^current_user_id])
  end

  def get_ten_json(tournament_id, player_id) do
    query = from c in K2pokerIo.Chat,
      where: c.tournament_id == ^tournament_id,
      join: u in assoc(c, :user),
      order_by: [desc: c.inserted_at],
      limit: 10,
      preload: :user
    comments = Repo.all query
    Enum.map(comments, fn (comment) -> K2pokerIo.Decorators.CommentDecorator.decorate(comment, player_id) end)
      |> Enum.reverse
  end

end
