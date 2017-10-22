defmodule K2pokerIo.Queries.Tournaments.GetTournamentsForUserQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.Invitation
  alias K2pokerIo.UserTournamentDetail

  import Ecto.Query

  #TODO: Join all these queries as one query

  def for_user(user_id) do
    %{public: get_public_tournaments(user_id),
      current: get_users_current_tournaments(user_id),
      invites: get_users_invitations(user_id)
    }
  end

  def get_public_tournaments(user_id) do
    player_id = "user-#{user_id}"
    query = from t in Tournament,
      where: (t.private == false and t.finished == false),
      left_join: utd in UserTournamentDetail, on: [tournament_id: t.id, player_id: ^player_id],
      select: [t.id, t.name, utd.current_score, t.starting_chips]
    Repo.all(query)
    |> Enum.map(fn [id, name, current_score, starting_chips] -> %{id: id, name: name, current_score: (current_score || starting_chips)} end)
  end

  def get_users_current_tournaments(user_id) do
    player_id = "user-#{user_id}"
    query = from i in Invitation,
      join: t in assoc(i, :tournament),
      left_join: utd in UserTournamentDetail, on: [tournament_id: t.id, player_id: ^player_id],
      where: (i.user_id == ^user_id and i.accepted == true and t.finished == false),
      order_by: [desc: t.inserted_at],
      select: [t.id, t.name, utd.current_score, t.starting_chips]
    Repo.all(query)
    |> Enum.map(fn [id, name, current_score, starting_chips] -> %{id: id, name: name, current_score: (current_score || starting_chips)} end)
  end

  def get_users_invitations(user_id) do
    query = from i in Invitation,
      join: t in assoc(i, :tournament),
      left_join: u in assoc(t, :user),
      where: (i.user_id == ^user_id and i.accepted == false and t.finished == false),
      order_by: [desc: i.inserted_at],
      select: [t.name, i.id, u.username, t.id]
    Repo.all(query)
    |> Enum.map(fn [name, id, username, tournament_id] -> %{name: name, id: id, username: username, tournament_id: tournament_id} end)
  end

end
