defmodule K2pokerIoWeb.Commands.Invitation.AcceptCommand do

  alias K2pokerIo.Repo
  alias K2pokerIo.Tournament
  alias K2pokerIo.Invitation

  import Ecto
  import Ecto.Query

  def execute(current_user, invite_id) do
    update_invitation(current_user, invite_id)
  end

  def update_invitation(current_user, invite_id) do
    invite = Repo.get(Invitation, invite_id)
    if current_user.id == invite.user_id do
      changeset = Invitation.changeset(invite, %{accepted: true})
      Repo.update(changeset)
    end
  end

end