defmodule K2pokerIo.ProfileControllerTest do

  use K2pokerIoWeb.ConnCase
  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.Commands.Badges.AddUserBadgeCommand
  alias K2pokerIo.Badge

  import Plug.Test

  doctest K2pokerIoWeb.ProfileController

  setup do
    %{player: Helpers.create_user("stu")}
  end

  test "#edit", %{conn: conn, player: player} do
    conn = init_test_session(conn, player_id: User.player_id(player))
    conn = get(conn, "/profile")
    expected = ~r/body\ class.*profile\ edit/
    assert html_response(conn, 200) =~ expected
  end

  test "#update_blurb should pass 2 badges down the line", context do

    Repo.insert!(%Badge{
      name: "My Profile",
      description: "Update your Bio",
      action: "update_bio",
      image: "profile",
      group: 1,
      position: 1,
      gold: false
    })

    Repo.insert!(%Badge{
      name: "Friends",
      description: "Make 5 friends",
      action: "5_friends",
      image: "friends",
      group: 1,
      position: 2,
      gold: false
    })

    Repo.insert!(%Badge{
      name: "Chat",
      description: "Start a converstion, (5 or more chats)",
      action: "5_chats",
      image: "chat",
      group: 1,
      position: 3,
      gold: false
    })

    Repo.insert!(%Badge{
      name: "Social Media Connect",
      description: "Connect a social media account",
      action: "social_connect",
      image: "social",
      group: 1,
      position: 4,
      gold: false
    })

    gold_badge = Repo.insert!(%Badge{
      name: "Party Animal",
      description: "Collect all the Social Badges",
      action: "complete_group",
      image: "gold-phone",
      group: 1,
      position: 5,
      gold: true
    })

    player = context.player
    AddUserBadgeCommand.execute("5_friends", player.id)
    AddUserBadgeCommand.execute("5_chats", player.id)
    AddUserBadgeCommand.execute("social_connect", player.id)

    conn = init_test_session(context.conn, player_id: User.player_id(player))
    response = conn
      |> post(profile_path(conn, :update_blurb, %{blurb: "updating my bio"}))
      |> json_response(200)
    %{"badges" => badges, "blurb" => blurb} = response
    badge = List.last(badges)
    assert(blurb == "updating my bio")
    assert(Enum.count(badges) == 2)
    assert(badge["id"] == gold_badge.id)
    assert(badge["name"] == gold_badge.name)
    assert(badge["description"] == gold_badge.description)
    assert(badge["image"] == gold_badge.image)
    assert(badge["achieved"])
  end

end
