defmodule K2pokerIo.Commands.Tournament.GetPlayerCount do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail

  import Ecto.Query

  def execute(tournament_id) do
    get_player_count(tournament_id)
  end

  def get_player_count(tournament_id) do
    query = from utd in UserTournamentDetail,
      select: count(utd.id),
      where: utd.tournament_id == ^tournament_id,
      where: utd.updated_at > datetime_add(^Ecto.DateTime.utc, -10, "minute")
    count = Repo.one(query)
    case count do
      0 -> 1
      _ -> count
    end
  end

end
