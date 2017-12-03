defmodule K2pokerIo.Queries.Tournaments.PlayersUnfinishedTournamentsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament

  import Ecto.Query

  def unfinished_duels(user_id) do
    duel_params = [private: true, starting_chips: 1024, lose_type: "half", finished: false]
    tournament_ids_by_invitations(user_id, duel_params)
  end

  defp tournament_ids_by_invitations(user_id, tournament_params) do
    query = from t in Tournament,
      join: i in assoc(t, :invitations),
      select: t.id,
      where: i.user_id == ^user_id,
      where: ^tournament_params
    Repo.all(query)
  end

end
