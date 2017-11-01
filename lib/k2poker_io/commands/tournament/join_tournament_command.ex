defmodule K2pokerIo.Commands.Tournament.JoinTournamentCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Tournament
  alias K2pokerIo.Invitation
  alias K2pokerIo.User

  import Ecto.Query

  def execute(current_user, tournament_id) do
    tournament = Repo.get(Tournament, tournament_id)
    if user_has_access?(current_user, tournament) do
      find_or_create_user_tournament_detail(current_user, tournament)
    else
      {:error, :unauthorized_tournament}
    end
  end

  defp user_has_access?(current_user, tournament) do
    if tournament.private do
      Repo.one(from i in Invitation, where: [user_id: ^current_user.id, tournament_id: ^tournament.id])
    else
      signed_in?(current_user)
    end
  end

  defp find_or_create_user_tournament_detail(current_user, tournament) do
    player_id = User.player_id(current_user)
    if utd = Repo.get_by(UserTournamentDetail, player_id: player_id, tournament_id: tournament.id) do
      {:ok, utd_id: utd.id}
    else
      detail = %{player_id: player_id, username: current_user.username, tournament_id: tournament.id, current_score: tournament.starting_chips, rebuys: [0]}
      changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
      case Repo.insert(changeset) do
        {:ok, utd} ->
          {:ok, utd_id: utd.id}
        {:error, _} ->
          {:error}
      end
    end
  end

  defp signed_in?(current_user) do
    current_user
  end

end
