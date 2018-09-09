defmodule K2pokerIo.Queries.Tournaments.GetPlayersQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Invitation
  alias K2pokerIo.User

  import Ecto.Query

  def all(tournament_id) do
    players_started = players_started(tournament_id)
    outstanding_invites = outstanding_invites(tournament_id, players_started)
    players_started ++ outstanding_invites
  end

  def top_five(tournament_id) do
    query = from utd in UserTournamentDetail,
      left_join: u in User, on: u.id == utd.user_id,
      select: %{player_id: utd.player_id, last_seen: utd.updated_at, username: utd.username, current_score: utd.current_score, invite: false, image: u.image},
      where: utd.tournament_id == ^tournament_id and utd.updated_at > ^one_hour_ago(),
      order_by: [desc: :current_score, desc: :updated_at],
      limit: 5
    Repo.all(query)
  end

  def registered_count(tournament_id) do
    query = from utd in UserTournamentDetail,
      select: count(utd.id),
      where: utd.tournament_id == ^tournament_id
    Repo.one(query)
  end

  def invited_count(tournament_id) do
    query = from invite in Invitation,
      select: count(invite.id),
      where: invite.tournament_id == ^tournament_id
    Repo.one(query)
  end

  def count(tournament_id) do
    query = from utd in UserTournamentDetail,
      select: count(utd.id),
      where: utd.tournament_id == ^tournament_id,
      where: utd.updated_at > ^one_hour_ago()
    count = Repo.one(query)
    case count do
      0 -> 1
      _ -> count
    end
  end

  # TODO this is limited to 100 so tournament count will be max 100, we probably need to use the
  # above count to correctly obtain the number of players
  defp players_started(tournament_id) do
    query = from utd in UserTournamentDetail,
      left_join: u in User, on: u.id == utd.user_id,
      select: %{player_id: utd.player_id, last_seen: utd.updated_at, username: utd.username, current_score: utd.current_score, invite: false, image: u.image},
      where: utd.tournament_id == ^tournament_id and utd.updated_at > ^one_hour_ago(),
      order_by: [desc: :current_score, desc: :updated_at],
      limit: 100
    Repo.all(query)
  end

  defp outstanding_invites(tournament_id, players_started) do
    started_user_ids = started_user_ids(players_started)
    query = from i in Invitation,
      join: u in User,
      where: i.user_id == u.id,
      select: %{player_id: nil, username: u.username, invite: true, last_seen: nil, current_score: nil, image: u.image},
      where: i.tournament_id == ^tournament_id and not i.user_id in ^started_user_ids
    Repo.all(query)
  end

  defp started_user_ids(players_started) do
    Enum.map(players_started, fn(x) -> User.get_id(x.player_id) end)
      |> Enum.reject(fn(x) -> elem(x,0) != :user end)
      |> Enum.map(fn(x) -> elem(x,1) end)
  end

  defp one_hour_ago do
    Timex.now |> Timex.shift(minutes: -60)
  end

end
