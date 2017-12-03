defmodule K2pokerIo.Policies.Tournament.AccessPolicy do

  alias K2pokerIo.Repo
  alias K2pokerIo.Invitation

  import Ecto.Query

  def accessible?(current_user, tournament) do
    if tournament.private do
      Repo.one(from i in Invitation, where: [user_id: ^current_user.id, tournament_id: ^tournament.id])
    else
      current_user #signed_in
    end
  end

end
