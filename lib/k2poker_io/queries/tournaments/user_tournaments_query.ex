defmodule K2pokerIo.Queries.Tournaments.UserTournamentsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.User
  alias K2pokerIo.Tournament
  alias K2pokerIo.Invitation
  alias K2pokerIo.UserTournamentDetail

  import Ecto.Query

  def all(current_user, params) do
    current_user_id = current_user.id
    player_id = User.player_id(current_user)
    query = from t in Tournament,
      left_join: i in assoc(t, :invitations),
      left_join: utd in assoc(t, :user_tournament_details), on: [tournament_id: t.id, player_id: ^player_id],
      where: (t.private == false and t.finished == false),
      or_where: (i.user_id == ^current_user_id and i.accepted == true and t.finished == false),
      select: %{id: t.id, name: t.name, current_score: utd.current_score, starting_chips: t.starting_chips}
    Repo.paginate(query)
  end

end
