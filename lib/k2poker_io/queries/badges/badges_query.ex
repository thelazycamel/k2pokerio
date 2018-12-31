defmodule K2pokerIo.Queries.Badges.BadgesQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Badge

  import Ecto.Query

  def all_by_user(current_user) do
    Repo.all(
      from b in Badge,
      order_by: [:group, :position],
      select: %{name: b.name, description: b.description, group: b.group, position: b.position, image: b.image}
    )
  end

  def golds(current_user) do
    
  end

end
