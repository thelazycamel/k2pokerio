defmodule K2pokerIo.CreateTournamentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand
  alias K2pokerIo.Friendship
  alias K2pokerIo.Invitation
  alias K2pokerIo.Repo

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.CreateTournamentCommand

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    player3 = Helpers.create_user("pip")
    player4 = Helpers.create_user("salma")
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player4.id, status: true}))
    %{player1: player1, player2: player2, player3: player3, player4: player4}
  end

  test "it should create a tournament with invitations", context do
    params = %{
      "game_type" => "tournament",
      "name" => "My Test Tournament",
      "friend_ids" => [context.player2.id,context.player3.id,context.player4.id]
      }
    {:ok, tournament} = CreateTournamentCommand.execute(context.player1, params)
    invite_count = Repo.one(from i in Invitation, where: i.tournament_id == ^tournament.id, select: count(i.id))
    assert(tournament.name == "My Test Tournament")
    assert(tournament.lose_type == "all")
    assert(invite_count == 4)
  end

  test "it should create a duel with invitations", context do
    params = %{
      "game_type" => "duel",
      "friend_ids" => [context.player2.id],
      "name" => "bob vs stu"
      }
    {:ok, tournament} = CreateTournamentCommand.execute(context.player1, params)
    invite_count = Repo.one(from i in Invitation, where: i.tournament_id == ^tournament.id, select: count(i.id))
    assert(tournament.name == "bob vs stu")
    assert(tournament.lose_type == "half")
    assert(invite_count == 2)
  end

  test "it should not send invitations to non-friends", context do
    player5 = Helpers.create_user("enemy")
    params = %{
      "game_type" => "tournament",
      "name" => "My Test Tournament",
      "friend_ids" => [context.player2.id,player5.id]
    }
    {:ok, tournament} = CreateTournamentCommand.execute(context.player1, params)
    invite_count = Repo.one(from i in Invitation, where: i.tournament_id == ^tournament.id, select: count(i.id))
    player5_invite = Repo.one(from i in Invitation, where: i.user_id == ^player5.id)
    assert(invite_count == 2)
    refute(player5_invite)
  end

  test "it should not allow the creation of a duel if one already exists between the 2 players", context do
    params = %{
      "game_type" => "duel",
      "name" => "Duel 1",
      "friend_ids" => [context.player2.id]
    }
    {:ok, tournament_1} = CreateTournamentCommand.execute(context.player1, params)
    refute(tournament_1.finished)
    {error, _} = CreateTournamentCommand.execute(context.player1, params)
    assert(error == :error)
  end

end

