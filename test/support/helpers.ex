defmodule K2pokerIo.Test.Helpers do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game
  alias K2pokerIo.Tournament
  alias K2pokerIo.User
  alias K2pokerIo.UserStats
  alias K2pokerIo.Chat
  alias K2pokerIo.Invitation
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIo.Commands.Game.JoinGameCommand
  alias K2pokerIo.Commands.Game.GetDataCommand
  alias K2pokerIo.Commands.Game.EndGameCommand

  # basic_set_up(["bob","stu"]), sets up a game with
  # 2 anonamous players and returns a map
  # %{player1: p1, player2: p2, game: game, tournament: tournament} (where p1, p2 are user_tournament_details)
  #
  def basic_set_up(players) do
    tournament = create_tournament()
    utds = create_anon_user_tournament_details(tournament, players)
    game = create_game(utds)
    %{
      player1: Repo.get(UserTournamentDetail, List.first(utds).id),
      player2: Repo.get(UserTournamentDetail, List.last(utds).id),
      tournament: tournament,
      game: game
     }
  end


  # advanced_set_up(["bob","stu"]), sets up a game with
  # 2 real players and returns a map
  # %{
  #    player1:    player1,
  #    player2:    player2,
  #    p1_utd:      p1_utd,
  #    p2_utd:      p2_utd,
  #    game:        game,
  #    tournament:  tournament
  #  }
  #

  def advanced_set_up(players) do
    tournament = create_tournament()
    player1 = create_user(List.first(players))
    player2 = create_user(List.last(players))
    p1_utd = create_user_tournament_detail(User.player_id(player1), player1.username, tournament.id)
    p2_utd = create_user_tournament_detail(User.player_id(player2), player2.username, tournament.id)
    game = create_game([p1_utd, p2_utd])
    %{
      tournament: tournament,
      player1:    player1,
      player2:    player2,
      p1_utd:     p1_utd,
      p2_utd:     p2_utd,
      game:       game
    }
  end

  def create_user_tournament_detail(player_id, username, tournament_id) do
    detail = %{player_id: player_id, username: username, tournament_id: tournament_id, current_score: 1, rebuys: [0]}
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
    Repo.insert!(changeset) |> Repo.preload(:tournament)
  end

  def create_user_tournament_detail(username, tournament_id) do
    player_id = anon_player_id(username)
    create_user_tournament_detail(player_id, username, tournament_id)
  end

  def create_duel(user, opponent) do
    Repo.insert!(%Tournament{
      name: "#{user.username} v #{opponent.username}",
      default_tournament: false,
      tournament_type: "duel",
      private: true,
      finished: false,
      user_id: user.id,
      lose_type: "half",
      starting_chips: 1024,
      max_score: 1048576,
      bots: false,
      rebuys: [0]
    })
  end

  def create_invitation(tournament_id, user_id, accepted) do
    Repo.insert(%Invitation{tournament_id: tournament_id, user_id: user_id, accepted: accepted})
  end

  def create_private_tournament(user, tournament_name) do
    Repo.insert!(%Tournament{
      name: tournament_name,
      default_tournament: false,
      private: true,
      tournament_type: "tournament",
      finished: false,
      user_id: user.id,
      lose_type: "all",
      starting_chips: 1,
      max_score: 1048576,
      bots: true,
      rebuys: [0]
    })
  end

  def create_open_tournament(user, tournament_name) do
    Repo.insert!(%Tournament{
      name: tournament_name,
      default_tournament: false,
      private: false,
      tournament_type: "tournament",
      finished: false,
      user_id: user.id,
      lose_type: "all",
      starting_chips: 1,
      max_score: 1048576,
      bots: true,
      rebuys: [0]
    })
  end

  def create_tournament do
    if Tournament.default do
      Tournament.default
    else
      Repo.insert!(%Tournament{name: "K2 Summit", description: "K2 Summit is the big one, play against everyone in this free and open tournament, always available.", default_tournament: true, tournament_type: "tournament", private: false, finished: false, rebuys: [0]})
    end
  end

  def create_user(username) do
    email = "#{username}=#{:rand.uniform(100000000)}@test.com"
    Repo.insert!(%User{username: username, email: email, password: "password"})
  end

  def create_user_stats(user) do
    Repo.insert!(UserStats.changeset(
      %UserStats{},
        %{
          user_id: user.id,
          games_played: 0,
          games_won: 0,
          games_lost: 0,
          games_folded: 0,
          tournaments_won: 0,
          duels_won: 0,
          top_score: 0
        }
      )
    )
  end

  def create_chat(tournament_id, user_id, comment, admin) do
    Repo.insert!(%Chat{
      tournament_id: tournament_id,
      user_id: user_id,
      comment: comment,
      admin: admin}
    )
  end

  def join_game(user_tournament_detail) do
    JoinGameCommand.execute(user_tournament_detail)
  end

  def create_game(utds) do
    games = Enum.map(utds, fn(user_tournament_detail) ->
      join_game(user_tournament_detail)
    end)
    {:ok, game} = List.last(games)
    game
  end

  def update_scores(game_id) do
    game = Repo.get(Game, game_id)
    EndGameCommand.execute(game)
  end

  def get_player_data(game_id, player_id) do
    GetDataCommand.execute(game_id, player_id)
  end

  def set_scores(player1_id, player2_id, score) do
    p1_utd = Repo.get_by(UserTournamentDetail, player_id: player1_id)
    p2_utd = Repo.get_by(UserTournamentDetail, player_id: player2_id)
    Repo.update(UserTournamentDetail.changeset(p1_utd, %{current_score: score}))
    Repo.update(UserTournamentDetail.changeset(p2_utd, %{current_score: score}))
    :ok
  end

  def player_wins(game, player_id) do
    other_player = get_other_player_id(game, player_id)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player_id, cards: ["As", "Ac"], status: "new"},
        %K2poker.Player{id: other_player, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Ad", "Ah", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: player_id,
        status: "win",
        cards: ["As", "Ac", "Ad", "Ah", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    return_updated_game(game, game_data)
  end

  def player_loses(game, player_id) do
    other_player = get_other_player_id(game, player_id)
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player_id, cards: ["2s", "3c"], status: "new"},
        %K2poker.Player{id: other_player, cards: ["Ac", "As"], status: "new"}
      ],
      table_cards: ["Ad", "Ah", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: other_player,
        status: "win",
        cards: ["As", "Ac", "Ad", "Ah", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    return_updated_game(game, game_data)
  end

  def players_draw(game, player1_id, player2_id) do
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player1_id, cards: ["2s", "3c"], status: "new"},
        %K2poker.Player{id: player2_id, cards: ["2h", "3d"], status: "new"}
      ],
      table_cards: ["Ad", "Ah", "4d", "5c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: "",
        status: "draw",
        cards: ["As", "Ac", "Ad", "Ah", "4h"],
        win_description: "two_pair",
        lose_description: ""
      }
    }
    return_updated_game(game, game_data)
  end

  def on_the_flop(game) do
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: game.player1_id, cards: ["As", "Ac"], status: "new"},
        %K2poker.Player{id: game.player2_id, cards: ["2s", "3c"], status: "new"}
      ],
      table_cards: ["Ad", "Ah", "3d"],
      status: "flop",
      deck: [],
      result: %K2poker.GameResult{
        player_id: "",
        status: "in_play",
        cards: [],
        win_description: "",
        lose_description: ""
      }
    }
    return_updated_game(game, game_data)
  end

  def player_folds(game, player_id) do
    decoded_game_data = Game.decode_game_data(game.data)
    game_data = K2poker.fold(decoded_game_data, player_id)
    return_updated_game(game, game_data)
  end

  #PRIVATE

  defp create_anon_user_tournament_details(tournament, players) do
    Enum.map(players, fn(player) ->
      create_user_tournament_detail(player, tournament.id)
    end)
  end

  defp anon_player_id(name) do
    "anon|" <> name <> random_hash(32)
  end

  defp random_hash(length) do
    :crypto.strong_rand_bytes(length) |> Base.url_encode64 |> binary_part(0, length) |> String.replace("|", "-")
  end

  defp return_updated_game(game, game_data) do
    encoded_game_data = Poison.encode!(game_data)
    changeset = Game.changeset(game, %{data: encoded_game_data})
    {:ok, game} = Repo.update(changeset)
    game
  end

  defp get_other_player_id(game, player_id) do
    case game.player1_id do
      ^player_id -> game.player2_id
      _ -> game.player1_id
    end
  end

end
