defmodule K2pokerIo.Queries.Friends.SearchFriendsQuery do

#  alias K2pokerIo.Repo
#  alias K2pokerIo.User
#  alias K2pokerIo.Friendship

#  import Ecto
#  import Ecto.Query

  #NOTE this query does not work, i have to associate through friend, see FriendsQuery

  #  def search(user_id, query_str) do
    #  query = from f in Friendship,
    #  join: u in assoc(f, :user),
      #  where: (f.user_id == ^user_id or f.friend_id == ^user_id) and (f.status == true) and (ilike(u.username, ^"%#{query_str}%")),
        #select: [u.id, u.username]
        #Repo.all(query)
        #|> Enum.into(%{}, fn [id, username] -> {id, username}end)
        #end

end
