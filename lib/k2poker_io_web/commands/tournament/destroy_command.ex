defmodule K2pokerIoWeb.Commands.Tournament.DestroyCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.Invitation
  alias K2pokerIo.UserTournamentDetail

  import Ecto
  import Ecto.Query

  def execute(current_user, tournament_id) do
    destroy_tournament(current_user, tournament_id)
  end

  defp destroy_tournament(current_user, tournament_id) do
    tournament = Repo.get(Tournament, tournament_id) |> Repo.preload(:invitations)
    if destroyable(current_user, tournament) do
      Repo.delete!(tournament)
    else
      remove_user_from_tournament(current_user, tournament)
    end
  end

  defp remove_user_from_tournament(current_user, tournament) do
    destroy_invitation(current_user, tournament)
    destroy_utd(current_user, tournament)
  end

  defp destroy_invitation(current_user, tournament) do
    if invitation = Repo.get_by(Invitation, user_id: current_user.id, tournament_id: tournament.id) do
      Repo.delete!(invitation)
    end
  end

  defp destroy_utd(current_user, tournament) do
    player_id = "user-#{current_user.id}"
    if utd = Repo.get_by(UserTournamentDetail, player_id: player_id, tournament_id: tournament.id) do
      Repo.delete!(utd)
    end
  end

  defp destroyable(current_user, tournament) do
    (current_user == tournament.user) || (Enum.count(tournament.invitations) <= 2 && tournament.private)
  end

end
