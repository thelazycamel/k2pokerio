defmodule K2pokerIo.UpdatePlayerScoreCommandTest do

  alias K2pokerIo.Test.Helpers
  alias K2pokerIo.User
  alias K2pokerIo.Friendship
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Tournament.CreateTournamentCommand
  alias K2pokerIo.Commands.Tournament.JoinTournamentCommand
  alias K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand

  alias K2pokerIo.Repo

  import Ecto.Query

  use K2pokerIo.ModelCase

  doctest K2pokerIo.Commands.Tournament.UpdatePlayerScoreCommand

  setup do
    setup = Helpers.advanced_set_up(["bob", "stu"])
    player1_id = User.player_id(setup.player1)
    player2_id = User.player_id(setup.player2)
    tournament_id = setup.tournament.id
    Repo.insert(Friendship.changeset(%Friendship{}, %{user_id: setup.player1.id, friend_id: setup.player2.id, status: true}))
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^tournament_id])
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player2_id, tournament_id: ^tournament_id])
    Repo.update(UserTournamentDetail.changeset(p1_utd, %{current_score: 8}))
    Repo.update(UserTournamentDetail.changeset(p2_utd, %{current_score: 8}))
    setup
  end

  test "it should double the players score if they win", context do
    player_id = User.player_id(context.player1)
    game = Helpers.player_wins(context.game, player_id)
    UpdatePlayerScoreCommand.execute(game, player_id)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player_id, tournament_id: ^context.tournament.id])
    assert(utd.current_score == 16)
  end

  test "it should reset the players score to 1 if they lose (tournament)", context do
    player_id = User.player_id(context.player1)
    game = Helpers.player_loses(context.game, player_id)
    UpdatePlayerScoreCommand.execute(game, player_id)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player_id, tournament_id: ^context.tournament.id])
    assert(utd.current_score == 1)
  end

  test "it should half the players score if they fold", context do
    player_id = User.player_id(context.player1)
    game = Helpers.player_folds(context.game, player_id)
    UpdatePlayerScoreCommand.execute(game, player_id)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player_id, tournament_id: ^context.tournament.id])
    assert(utd.current_score == 4)
  end

  test "it should keep the same score if the other player has folded", context do
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game = Helpers.player_folds(context.game, player2_id)
    UpdatePlayerScoreCommand.execute(game, player1_id)
    utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^context.tournament.id])
    assert(utd.current_score == 8)
  end

  test "it should keep the same score if its a draw", context do
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    game = Helpers.players_draw(context.game, player1_id, player2_id)
    UpdatePlayerScoreCommand.execute(game, player1_id)
    UpdatePlayerScoreCommand.execute(game, player2_id)
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player1_id, tournament_id: ^context.tournament.id])
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: [player_id: ^player2_id, tournament_id: ^context.tournament.id])
    assert(p1_utd.current_score == 8)
    assert(p2_utd.current_score == 8)
  end


  test "it should double the winner and half the loser scores (duel)", context do
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    params = %{
      "game_type" => "duel",
      "user_id" => context.player1.id,
      "friend_ids" => to_string(context.player2.id)
      }
    {:ok, duel} = CreateTournamentCommand.execute(context.player1, params)
    {:ok, [utd_id: p1_utd_id]} = JoinTournamentCommand.execute(context.player1, duel.id)
    {:ok, [utd_id: p2_utd_id]} = JoinTournamentCommand.execute(context.player2, duel.id)
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p1_utd_id, preload: :tournament)
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p2_utd_id, preload: :tournament)
    game = Helpers.create_game([p1_utd, p2_utd])
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p1_utd_id, preload: :tournament)
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p2_utd_id, preload: :tournament)
    assert(p1_utd.current_score == 1024)
    assert(p2_utd.current_score == 1024)
    game = Helpers.player_wins(game, player1_id)
    UpdatePlayerScoreCommand.execute(game, player1_id)
    UpdatePlayerScoreCommand.execute(game, player2_id)
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p1_utd_id, preload: :tournament)
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p2_utd_id, preload: :tournament)
    assert(p1_utd.current_score == 2048)
    assert(p2_utd.current_score == 512)
  end

  test "it should return 1 if halved score is less than 1 (duel)", context do
    player1_id = User.player_id(context.player1)
    player2_id = User.player_id(context.player2)
    params = %{
      "game_type" => "duel",
      "user_id" => context.player1.id,
      "friend_ids" => to_string(context.player2.id)
      }
    {:ok, duel} = CreateTournamentCommand.execute(context.player1, params)
    {:ok, [utd_id: p1_utd_id]} = JoinTournamentCommand.execute(context.player1, duel.id)
    {:ok, [utd_id: p2_utd_id]} = JoinTournamentCommand.execute(context.player2, duel.id)
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p1_utd_id, preload: :tournament)
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p2_utd_id, preload: :tournament)
    game = Helpers.create_game([p1_utd, p2_utd])
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p1_utd_id, preload: :tournament)
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p2_utd_id, preload: :tournament)
    p1_utd = Repo.update!(UserTournamentDetail.changeset(p1_utd, %{current_score: 524288}))
    p2_utd = Repo.update!(UserTournamentDetail.changeset(p2_utd, %{current_score: 1}))
    assert(p1_utd.current_score == 524288)
    assert(p2_utd.current_score == 1)
    game = Helpers.player_wins(game, player1_id)
    UpdatePlayerScoreCommand.execute(game, player1_id)
    UpdatePlayerScoreCommand.execute(game, player2_id)
    p1_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p1_utd_id, preload: :tournament)
    p2_utd = Repo.one(from utd in UserTournamentDetail, where: utd.id == ^p2_utd_id, preload: :tournament)
    assert(p1_utd.current_score == 1048576)
    assert(p2_utd.current_score == 1)
  end

  # DUEL updating fold status
  test "it should update the utd with fold false if player folds", %{player1: player1, player2: player2} do
    player1_id = User.player_id(player1)
    player2_id = User.player_id(player2)
    duel = Helpers.create_duel(player1, player2)
    p1_utd = Helpers.create_user_tournament_detail(player1_id, player1.username, duel.id)
    p2_utd = Helpers.create_user_tournament_detail(player2_id, player2.username, duel.id)
    Helpers.create_game([p1_utd, p2_utd])
    |> Helpers.player_folds(player1_id)
    |> UpdatePlayerScoreCommand.execute(player1_id)
    |> UpdatePlayerScoreCommand.execute(player2_id)
    p1_utd = Repo.get(UserTournamentDetail, p1_utd.id)
    p2_utd = Repo.get(UserTournamentDetail, p2_utd.id)
    refute(p1_utd.fold)
    assert(p2_utd.fold)
  end

end
