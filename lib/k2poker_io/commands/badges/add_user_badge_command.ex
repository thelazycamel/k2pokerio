defmodule K2pokerIo.Commands.Badges.AddUserBadgeCommand do

  alias K2pokerIo.UserBadge
  alias K2pokerIo.Repo
  alias K2pokerIo.Queries.Badges.BadgesQuery

  def execute(action, user_id) do
    BadgesQuery.by_action(action, user_id)
    |> update_badge(user_id)
  end

  def update_badge(badge, user_id) do
    if badge && !badge.achieved do
      Repo.insert!(UserBadge.changeset(%UserBadge{}, %{badge_id: badge.id, user_id: user_id}))
      check_for_complete_group(badge, user_id)
    end
  end

  #TODO check if all group badges have been achieved
  def check_for_complete_group(badge, user_id) do
    true
  end

end
