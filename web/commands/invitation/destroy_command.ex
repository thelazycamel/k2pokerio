defmodule K2pokerIo.Commands.Invitation.DestroyCommand do

  alias K2pokerIo.Tournament
  alias K2pokerIo.Invitation
  alias K2pokerIo.Repo
  import Ecto
  import Ecto.Query

  def execute(current_user, invite_id) do
    destroy_invitation(current_user, invite_id)
    |> destroy_tournament(current_user)
  end

  def destroy_invitation(current_user, invite_id) do
    invite = Repo.get(Invitation, invite_id)
    if current_user.id == invite.user_id do
      Repo.delete!(invite)
    end
    invite.tournament_id
  end

  def destroy_tournament(tournament_id, current_user) do
    K2pokerIo.Commands.Tournament.DestroyCommand.execute(current_user, tournament_id)
  end

end
