defmodule K2pokerIo.BadgesQueryTest do

  alias K2pokerIo.Repo
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Badge
  alias K2pokerIo.UserBadge
  alias K2pokerIo.Queries.Badges.BadgesQuery

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Queries.Badges.BadgesQuery

  setup do
    player1 = Helpers.create_user("stu")
    player2 = Helpers.create_user("bob")

    badge1 = Repo.insert!(%Badge{
      name: "My Profile",
      description: "Update your Bio",
      action: "update_bio",
      image: "profile",
      group: 1,
      position: 1,
      gold: false
    })

    badge2 = Repo.insert!(%Badge{
      name: "Friends",
      description: "Make 5 friends",
      action: "5_friends",
      image: "friends",
      group: 1,
      position: 2,
      gold: false
    })

    badge3 = Repo.insert!(%Badge{
      name: "Party Animal",
      description: "Collect all the Social Badges",
      action: "complete_group",
      image: "gold-phone",
      group: 1,
      position: 5,
      gold: true
    })

    badge4 = Repo.insert!(%Badge{
      name: "Top Dog",
      description: "Collect all the Game Badges",
      action: "complete_group",
      image: "top-dog",
      group: 2,
      position: 5,
      gold: true
    })

    Repo.insert!(%UserBadge{user_id: player1.id, badge_id: badge1.id})
    Repo.insert!(%UserBadge{user_id: player1.id, badge_id: badge3.id})

    %{player1: player1, player2: player2, badge1: badge1, badge2: badge2, badge3: badge3, badge4: badge4}
  end

  test "#all_by_user should return correct results for player1", context do
    query = BadgesQuery.all_by_user(context.player1)
    badge1 = Enum.at(query, 0)
    badge2 = Enum.at(query, 1)
    badge3 = Enum.at(query, 2)
    badge4 = Enum.at(query, 3)
    assert(badge1.name == context.badge1.name)
    assert(badge2.name == context.badge2.name)
    assert(badge3.name == context.badge3.name)
    assert(badge4.name == context.badge4.name)
    assert(badge1.achieved)
    assert(badge3.achieved)
  end

  test "#all_by_user should return correct results for player2", context do
    query = BadgesQuery.all_by_user(context.player2)
    badge1 = Enum.at(query, 0)
    badge2 = Enum.at(query, 1)
    badge3 = Enum.at(query, 2)
    badge4 = Enum.at(query, 3)
    assert(badge1.name == context.badge1.name)
    assert(badge2.name == context.badge2.name)
    assert(badge3.name == context.badge3.name)
    assert(badge4.name == context.badge4.name)
    refute(badge1.achieved)
    refute(badge3.achieved)
  end

  test "#gold should return correct results for player1", context do
    query = BadgesQuery.gold_by_user(context.player1)
    badge3 = Enum.at(query, 0)
    badge4 = Enum.at(query, 1)
    assert(Enum.count(query) == 2)
    assert(badge3.name == context.badge3.name)
    assert(badge4.name == context.badge4.name)
    assert(badge3.achieved)
    refute(badge4.achieved)
  end

  test "#gold should return correct results for player2", context do
    query = BadgesQuery.gold_by_user(context.player2)
    badge3 = Enum.at(query, 0)
    badge4 = Enum.at(query, 1)
    assert(Enum.count(query) == 2)
    assert(badge3.name == context.badge3.name)
    assert(badge4.name == context.badge4.name)
    refute(badge3.achieved)
    refute(badge4.achieved)
  end

  test "#by_action should return the badge id and achieved", context do
    badge = BadgesQuery.by_action("update_bio", context.player1.id)
    badge2 = BadgesQuery.by_action("5_friends", context.player2.id)
    assert(badge.id == context.badge1.id)
    assert(badge.group == context.badge1.group)
    assert(badge.achieved)
    assert(badge2.id == context.badge2.id)
    assert(badge2.group == context.badge2.group)
    refute(badge2.achieved)
  end

end
