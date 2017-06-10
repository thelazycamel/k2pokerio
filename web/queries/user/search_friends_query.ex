defmodule K2pokerIo.Queries.User.SearchFriendsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Friendship
  import Ecto
  import Ecto.Query

  def search(user_id, query) do
    query = from f in Friendship,
      join: u in assoc(f, :user),
      where: (f.user_id == ^user_id or f.friend_id == ^user_id) and (f.status == true) and (ilike(u.username, ^"%#{query}%")),
      select: [u.id, u.username]
    Repo.all(query)
  end

end
