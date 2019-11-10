defmodule K2pokerIo.AddUserBadgeCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Badges.AddUserBadgeCommand
  alias K2pokerIo.Queries.Badges.BadgesQuery
  alias K2pokerIo.Badge
  alias K2pokerIo.UserBadge
  alias K2pokerIo.Repo

  import Ecto.Query

  use K2pokerIo.DataCase

  doctest K2pokerIo.Commands.Badges.AddUserBadgeCommand

  setup do

    Repo.insert!(%Badge{
      name: "Four Jacks",
      description: "Win with four Jacks",
      image: "jacks",
      action: "4_jacks",
      group: 5,
      position: 1,
      gold: false
    })

    Repo.insert!(%Badge{
      name: "Four Queens",
      description: "Win with four Queens",
      image: "queens",
      action: "4_queens",
      group: 5,
      position: 2,
      gold: false
    })

    Repo.insert!(%Badge{
      name: "Four Kings",
      description: "Win with four Kings",
      image: "kings",
      action: "4_kings",
      group: 5,
      position: 3,
      gold: false
    })

    Repo.insert!(%Badge{
      name: "Four Aces",
      description: "Win with four Aces",
      image: "aces",
      action: "4_aces",
      group: 5,
      position: 4,
      gold: false
    })

    Repo.insert!(%Badge{
      name: "Fantastic Fours",
      description: "Collect all the 'Four-of-a-kind' Badges",
      action: "complete_group",
      image: "fantastic-fours",
      group: 5,
      position: 5,
      gold: true
    })

    Helpers.advanced_set_up(["bob", "stu"])
  end

  test "it should add one badge for the user", context do
    user_id = context.player1.id
    AddUserBadgeCommand.execute("4_jacks", user_id)
    count = Repo.one(
      from ub in UserBadge,
      where: [user_id: ^user_id],
      select: count(ub.id)
    )
    assert(count == 1)
  end

  test "it should not add the same badge twice", context do
    user_id = context.player1.id
    AddUserBadgeCommand.execute("4_jacks", user_id)
    AddUserBadgeCommand.execute("4_jacks", user_id)
    count = Repo.one(
      from ub in UserBadge,
      where: [user_id: ^user_id],
      select: count(ub.id)
    )
    assert(count == 1)
  end

  test "it should add the gold badge for the user", context do
    user_id = context.player1.id
    AddUserBadgeCommand.execute("4_jacks", user_id)
    AddUserBadgeCommand.execute("4_queens", user_id)
    AddUserBadgeCommand.execute("4_kings", user_id)
    {:ok, badges_awarded} = AddUserBadgeCommand.execute("4_aces", user_id)
    query = BadgesQuery.all_by_user(context.player1)
    gold_badge = List.last(query)
    assert(Enum.count(badges_awarded) == 2)
    assert(gold_badge.name == List.last(badges_awarded).name)
    assert(Enum.count(query) == 5)
    assert(gold_badge.name == "Fantastic Fours")
    assert(gold_badge.gold)
    assert(gold_badge.achieved)
  end

end
