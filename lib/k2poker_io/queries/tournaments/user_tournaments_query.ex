defmodule K2pokerIo.Queries.Tournaments.UserTournamentsQuery do

  alias K2pokerIo.User
  alias K2pokerIo.Tournament

  import Ecto.Query
  import K2pokerIo.Queries.Pagination

  def all(current_user, params) do
    current_user_id = current_user.id
    player_id = User.player_id(current_user)
    query = from t in Tournament,
      left_join: i in assoc(t, :invitations),
      left_join: utd in assoc(t, :user_tournament_details), on: [tournament_id: t.id, player_id: ^player_id],
      where: (t.private == false and t.finished == false),
      or_where: (i.user_id == ^current_user_id and i.accepted == true and t.finished == false),
      order_by: [t.private, t.inserted_at],
      select: %{id: t.id, name: t.name, current_score: utd.current_score, starting_chips: t.starting_chips, private: t.private, image: t.image}
    paginate(query, params)
  end

end
