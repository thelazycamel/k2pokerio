defmodule K2pokerIo.TournamentChannelTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIoWeb.TournamentChannel
  alias K2pokerIo.User
  alias K2pokerIo.Badge

  use K2pokerIoWeb.ChannelCase

  doctest K2pokerIoWeb.TournamentChannel

  setup do
    tournament = Helpers.create_tournament()
    player = Helpers.create_user("bob")
    other_player = Helpers.create_user("stu")
    %{player: player, other_player: other_player, tournament: tournament}
  end

  test "Joining broadcasts the new user count", context do
    Helpers.create_user_tournament_detail(User.player_id(context.player), "bob", context.tournament.id)
    Helpers.create_user_tournament_detail(User.player_id(context.other_player), "stu", context.tournament.id)
    {:ok, _, _} = socket("", %{current_user: context.player, player_id: User.player_id(context.player)})
      |> subscribe_and_join(TournamentChannel, "tournament:#{ context.tournament.id}")
    assert_broadcast("tournament:update", %{})
  end

  test "tournament:loser does not send message to winner", context do
    player_id = K2pokerIo.User.player_id(context.player)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(TournamentChannel, "tournament:#{ context.tournament.id}")
    broadcast_from! socket, "tournament:loser", %{username: "bob", player_id: player_id}
    refute_push("tournament:loser", %{username: "bob", player_id: ^player_id})
    leave socket
  end

  test "tournament:loser sends message to the losers", context do
    player_id = K2pokerIo.User.player_id(context.player)
    other_player_id = K2pokerIo.User.player_id(context.other_player)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(TournamentChannel, "tournament:#{ context.tournament.id}")
    broadcast_from! socket, "tournament:loser", %{username: "stu", player_id: other_player_id}
    assert_push("tournament:loser", %{username: "stu", player_id: ^other_player_id})
    leave socket
  end

  test "tournament:winner sends message to the winner", context do
    player_id = K2pokerIo.User.player_id(context.player)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(TournamentChannel, "tournament:#{ context.tournament.id}")
    broadcast_from! socket, "tournament:winner", %{username: "bob", player_id: player_id}
    assert_push("tournament:winner", %{username: "bob", player_id: ^player_id})
    leave socket
  end

  test "tournament:winner does not send message to the losers", context do
    player_id = K2pokerIo.User.player_id(context.player)
    other_player_id = K2pokerIo.User.player_id(context.other_player)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(TournamentChannel, "tournament:#{ context.tournament.id}")
    broadcast_from! socket, "tournament:winner", %{username: "stu", player_id: other_player_id}
    refute_push("tournament:winner", %{username: "stu", player_id: ^other_player_id})
    leave socket
  end

  test "tournament:badge_awarded sends message to user getting the badge", context do

    badge1 = Repo.insert!(%Badge{
      name: "Four Queens",
      description: "Win with four Queens",
      image: "queens",
      action: "4_queens",
      group: 5,
      position: 2,
      gold: false
    })

    badge2 = Repo.insert!(%Badge{
      name: "Four Kings",
      description: "Win with four Kings",
      image: "kings",
      action: "4_kings",
      group: 5,
      position: 3,
      gold: false
    })
    badges = [badge1,badge2]
    player_id = K2pokerIo.User.player_id(context.player)
    {:ok, _, socket} = socket("", %{player_id: player_id})
      |> subscribe_and_join(TournamentChannel, "tournament:#{ context.tournament.id}")
    broadcast_from! socket, "tournament:badge_achieved", %{player_id: player_id, badges: badges}
    assert_push("tournament:badge_achieved", %{player_id: ^player_id, badges: badges})
    leave socket
  end

end
