defmodule K2pokerIo.Commands.Badges.AddUserBadgeCommand do

  alias K2pokerIo.Badge
  alias K2pokerIo.UserBadge
  alias K2pokerIo.Repo
  alias K2pokerIo.Queries.Badges.BadgesQuery
  import Ecto.Query

  @doc "Adds badge/gold_badge if user doesnt already have it, returns tuple with {:ok, Array of Badges}"

  def execute(action, user_id) do
    BadgesQuery.by_action(action, user_id)
    |> update_badge(user_id)
  end

  def update_badge(badge, user_id) do
    if badge && !badge.achieved do
      Repo.insert!(UserBadge.changeset(%UserBadge{}, %{badge_id: badge.id, user_id: user_id}))
      check_for_complete_group(badge, user_id)
    else
      {:ok, []}
    end
  end

  defp check_for_complete_group(badge, user_id) do
    count = BadgesQuery.count_by_group(badge.group, user_id)
    if count == 4  do
      {:ok, [badge, add_gold_badge(badge, user_id)]}
    else
      {:ok, [badge]}
    end
  end

  defp add_gold_badge(badge, user_id) do
    group = badge.group
    gold_badge = Repo.one(
      from b in Badge,
      where: [group: ^group, gold: true],
      limit: 1
    )
    Repo.insert!(UserBadge.changeset(%UserBadge{}, %{badge_id: gold_badge.id, user_id: user_id}))
    gold_badge
  end

end
