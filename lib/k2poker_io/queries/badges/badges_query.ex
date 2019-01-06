defmodule K2pokerIo.Queries.Badges.BadgesQuery do

  alias K2pokerIo.Repo
  alias K2pokerIo.Badge
  alias K2pokerIo.UserBadge

  import Ecto.Query

  def by_action(action, current_user_id) do
    Repo.one(from b in Badge,
      where: [action: ^action],
      left_join: ub in assoc(b, :user_badges), on: [badge_id: b.id, user_id: ^current_user_id],
      select: %{id: b.id, group: b.group, name: b.name, description: b.description, image: b.image, achieved: ub.id},
      limit: 1
    )
  end

  def count_by_group(group, user_id) do
    Repo.one(
      from ub in UserBadge,
      left_join: b in assoc(ub, :badge),
      where: (b.group == ^group and ub.user_id == ^user_id),
      select: count(ub.id)
    )
  end

  def all_by_user(current_user) do
    current_user_id = current_user.id
    Repo.all(
      from b in Badge,
      left_join: ub in assoc(b, :user_badges), on: [badge_id: b.id, user_id: ^current_user_id],
      order_by: [:group, :position],
        select: %{name: b.name, description: b.description, group: b.group, position: b.position, image: b.image, gold: b.gold, achieved: ub.id}
    )
  end

  def gold_by_user(current_user) do
    current_user_id = current_user.id
    Repo.all(
      from b in Badge,
      left_join: ub in assoc(b, :user_badges), on: [badge_id: b.id, user_id: ^current_user_id],
      where: b.gold == true,
      order_by: [:group, :position],
        select: %{name: b.name, description: b.description, group: b.group, position: b.position, image: b.image, gold: b.gold, achieved: ub.id}
    )
  end

end
