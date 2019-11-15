defmodule K2pokerIo.Queries.Invitations.InvitationsQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Invitation

  import Ecto.Query

  def count(user_id) do
    Repo.one(from i in Invitation,
      where: [user_id: ^user_id, accepted: false],
      select: count(i.id)
    )
  end

  def all(current_user_id, params) do
    query = from i in Invitation,
      join: t in assoc(i, :tournament),
      left_join: u in assoc(t, :user),
      where: (i.user_id == ^current_user_id and i.accepted == false and t.finished == false),
      select: %{name: t.name, id: i.id, username: u.username, tournament_id: t.id, image: t.image},
      order_by: [desc: i.inserted_at]
    Repo.paginate(query, params)
  end

end
