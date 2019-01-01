defmodule K2pokerIo.BadgeControllerTest do

  use K2pokerIoWeb.ConnCase
  import Plug.Test

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.Badge
  alias K2pokerIo.Repo
  alias K2pokerIo.UserBadge

  doctest K2pokerIoWeb.BadgeController

  setup do
    player = Helpers.create_user("stu")

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
    Repo.insert!(%UserBadge{user_id: player.id, badge_id: badge1.id})

    %{player: player, badge1: badge1, badge2: badge2}
  end

  test "#index - should return a JSON representation of users friends", context do
    conn = init_test_session(context.conn, player_id: User.player_id(context.player))
    response = conn
      |> get(badge_path(conn, :index))
      |> json_response(200)
    %{"badges" => badges} = response
    first_badge = List.first(badges)
    second_badge = List.last(badges)
    assert(first_badge["name"] == context.badge1.name)
    refute(first_badge["gold"])
    assert(second_badge["name"] == context.badge2.name)
    assert(first_badge["achieved"])
    refute(second_badge["achieved"])
  end

end
