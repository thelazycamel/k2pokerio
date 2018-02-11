defmodule K2pokerIo.JoinTournamentCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.Friendship
  alias K2pokerIo.Tournament
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand
  alias K2pokerIo.Commands.Tournament.JoinTournamentCommand
  alias K2pokerIo.Repo

  import Ecto.Query

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.JoinTournamentCommand

  setup do
    player1 = Helpers.create_user("bob")
    player2 = Helpers.create_user("stu")
    player3 = Helpers.create_user("pip")
    player4 = Helpers.create_user("salma")
    #create friends
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player2.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player3.id, status: true}))
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: player1.id, friend_id: player4.id, status: true}))
    friend_ids = Enum.join([player2.id, player3.id], ",")
    #create the tournaments
    {:ok, private_tournament} = CreateTournamentCommand.execute(player1, %{"game_type" => "tournament", "name" => "My Test Tournament", "friend_ids" => friend_ids})
    freeroll_tournament = Repo.insert!(Tournament.changeset(%Tournament{}, %{
      name: "Test Tourney Freeroll",
      default_tournament: false,
      type: "tournament",
      private: false,
      user_id: nil,
      lose_type: "all",
      starting_chips: 1,
      max_score: 1048576,
      bots: true
    }))

    %{
      player1: player1,
      player2: player2,
      player3: player3,
      player4: player4,
      private_tournament: private_tournament,
      freeroll_tournament: freeroll_tournament
    }
  end

  test "invited user can join the private tournament", context do
    {:ok, utd} = JoinTournamentCommand.execute(context.player2, context.private_tournament.id)
    assert(utd[:utd_id])
  end

  test "uninvited user can not join the private tournament", context do
    {:error, message} = JoinTournamentCommand.execute(context.player4, context.private_tournament.id)
    assert(message == :unauthorized_tournament)
  end

  test "any signed_in user can join an open tournament", context do
    {:ok, utd} = JoinTournamentCommand.execute(context.player1, context.freeroll_tournament.id)
    assert(utd[:utd_id])
  end

  test "a logged out user can not join an open tournament", context do
    {:error, message} = JoinTournamentCommand.execute(nil, context.freeroll_tournament.id)
    assert(message == :unauthorized_tournament)
  end

  test "it creates a user_tournament_detail with a user_id", context do
    {:ok, [utd_id: utd_id]} = JoinTournamentCommand.execute(context.player1, context.private_tournament.id)
    utd = Repo.one(from u in UserTournamentDetail, where: u.id == ^utd_id)
    assert(utd.user_id == context.player1.id)
  end

end
