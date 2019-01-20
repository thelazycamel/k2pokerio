defmodule K2pokerIo.UpdateMiscBadgesCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Badges.UpdateMiscBadgesCommand
  alias K2pokerIo.Commands.Chat.CreateCommentCommand
  alias K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Friendship
  alias K2pokerIo.User
  alias K2pokerIo.Game
  alias K2pokerIo.Badge
  alias K2pokerIo.UserBadge
  alias K2pokerIo.Repo

  import Ecto.Query

  use K2pokerIoWeb.ConnCase
  import Plug.Test

  doctest K2pokerIo.Commands.Badges.UpdateMiscBadgesCommand

  setup do
    Helpers.advanced_set_up(["bob", "stu"])
  end

  test "Player gets 1024 on K2 Summit (Hill Climber Badge)", context do

    badge = Repo.insert!(%Badge{
      name: "Hill Climber",
      description: "Reach 1024 in K2 Summit",
      image: "hill-climber",
      action: "hill_climber",
      group: 2,
      position: 3,
      gold: false
    })

    utd = Repo.update!(UserTournamentDetail.changeset(context.p1_utd, %{current_score: 512}))

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)

    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Js", "Kh"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Jd", "Jh", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Js", "Jc", "Jd", "Kh", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))

    UpdatePlayerScoreCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Player gets 32768 on K2 Summit (High Flyer Badge)", context do

    badge = Repo.insert!(%Badge{
      name: "High Flyer",
      description: "Reach 32768 in K2 Summit",
      image: "high-flyer",
      action: "high_flyer",
      group: 2,
      position: 4,
      gold: false
    })

    utd = Repo.update!(UserTournamentDetail.changeset(context.p1_utd, %{current_score: 16384}))

    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)

    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["Js", "Kh"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Jd", "Jh", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player1_id,
        status: "win",
        cards: ["Js", "Jc", "Jd", "Kh", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    encoded_game_data = Poison.encode!(game_data)
    game = Repo.update!(Game.changeset(context.game, %{data: encoded_game_data}))

    UpdatePlayerScoreCommand.execute(game, player1_id)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    assert(user_badge)
  end

  test "Update my profile test ", context do

    badge = Repo.insert!(%Badge{
      name: "My Profile",
      description: "Update your Bio",
      action: "update_bio",
      image: "profile",
      group: 1,
      position: 1,
      gold: false
    })

    conn = init_test_session(context.conn, player_id: context.p1_utd.player_id)
    response = conn
      |> post(profile_path(conn, :update_blurb), %{"blurb" => "Hello, I am a teapot"})
      |> json_response(200)

    user_id = context.player1.id
    badge_id = badge.id

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])

    badge_for_alert = List.first(response["badges"])
    assert(badge_for_alert["name"] == "My Profile")
    assert(badge_for_alert["image"] == "profile")
    assert(badge_for_alert["description"] == "Update your Bio")
    assert(badge_for_alert["id"] == badge.id)
    assert(user_badge)
  end

  test "It should give a badge to any user with 5 friends", context do

    badge = Repo.insert!(%Badge{
      name: "Friends",
      description: "Make 5 friends",
      action: "5_friends",
      image: "friends",
      group: 1,
      position: 2,
      gold: false
    })

    player3 = Helpers.create_user("player3")
    player4 = Helpers.create_user("player4")
    player5 = Helpers.create_user("player5")
    player6 = Helpers.create_user("player6")
    player7 = Helpers.create_user("player7")
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: context.player1.id, friend_id: player3.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: context.player1.id, friend_id: player4.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: context.player1.id, friend_id: player5.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: context.player1.id, friend_id: player6.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player7.id, friend_id: player3.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player7.id, friend_id: player4.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player7.id, friend_id: player5.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player7.id, friend_id: player6.id, status: true}))
    Repo.insert!(Friendship.changeset(%Friendship{}, %{user_id: player7.id, friend_id: context.player1.id, status: false}))

    conn = init_test_session(context.conn, player_id: User.player_id(context.player1))
    response = conn
      |> post(friend_path(conn, :create, %{"id" => player7.id}))
      |> json_response(200)
    %{"friend" => status, "badges" => badges} = response

    user_id = context.player1.id
    player7_id = player7.id
    badge_id = badge.id
    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])
    friends_user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^player7_id, badge_id: ^badge_id])
    badge_for_alert = List.first(badges)

    assert(status == "friend")
    assert(badge_for_alert["id"] == badge.id)
    assert(badge_for_alert["name"] == "Friends")
    assert(badge_for_alert["image"] == "friends")
    assert(badge_for_alert["description"] == "Make 5 friends")
    assert(user_badge)
    assert(friends_user_badge)

  end

  test "It should give a badge after 5 comments", context do

    badge = Repo.insert!(%Badge{
      name: "Chat",
      description: "Start a converstion, (5 or more chats)",
      action: "5_chats",
      image: "chat",
      group: 1,
      position: 3,
      gold: false
    })

    user_id = context.player1.id
    badge_id = badge.id

    CreateCommentCommand.execute(%{tournament_id: context.tournament.id, user_id: user_id, comment: "first comment", admin: false})
    CreateCommentCommand.execute(%{tournament_id: context.tournament.id, user_id: user_id, comment: "second comment", admin: false})
    CreateCommentCommand.execute(%{tournament_id: context.tournament.id, user_id: user_id, comment: "third comment", admin: false})
    CreateCommentCommand.execute(%{tournament_id: context.tournament.id, user_id: user_id, comment: "fourth comment", admin: false})
    CreateCommentCommand.execute(%{tournament_id: context.tournament.id, user_id: user_id, comment: "fifth comment", admin: false})

    user_badge = Repo.one(from ub in UserBadge, where: [user_id: ^user_id, badge_id: ^badge_id])

    assert(user_badge)

  end

end
