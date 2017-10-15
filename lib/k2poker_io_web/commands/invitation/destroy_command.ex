defmodule K2pokerIoWeb.Commands.Invitation.DestroyCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Invitation

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
    K2pokerIoWeb.Commands.Tournament.DestroyCommand.execute(current_user, tournament_id)
  end

end
