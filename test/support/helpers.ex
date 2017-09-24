defmodule K2pokerIo.Test.Helpers do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game
  alias K2pokerIo.Tournament
  alias K2pokerIo.User
  alias K2pokerIo.Chat
  alias K2pokerIo.UserTournamentDetail
  alias K2pokerIoWeb.Commands.Game.JoinCommand
  alias K2pokerIoWeb.Commands.Game.GetDataCommand
  alias K2pokerIoWeb.Commands.Tournament.UpdateScoresCommand

  # basic_set_up, sets up a game with a List of 2 players and returns
  # a map %{player1: p1, player2: p2, game: game} (where p1, p2 are user_tournament_details)
  #
  def basic_set_up(players) do
    create_tournament
    |> create_user_tournament_details(players)
    |> create_game
  end

  def create_user_tournament_detail(username, tournament_id) do
    detail = %{player_id: anon_player_id(username), username: username, tournament_id: tournament_id, current_score: 1, rebuys: [0]}
    changeset = UserTournamentDetail.changeset(%UserTournamentDetail{}, detail)
    Repo.insert!(changeset) |> Repo.preload(:tournament)
  end

  def create_tournament do
    Repo.insert!(%Tournament{name: "K2 Summit Ascent Test", default: true, private: false, finished: false})
  end

  def create_user(username) do
    Repo.insert!(%User{username: username, email: "#{username}@test.com", password: "abc123"})
  end

  def create_chat(tournament_id, user_id, comment, admin) do
    Repo.insert!(%Chat{tournament_id: tournament_id, user_id: user_id, comment: comment, admin: admin})
  end

  def join_game(user_tournament_detail) do
    JoinCommand.execute(user_tournament_detail)
  end

  def create_game(utds) do
    games = Enum.map(utds, fn(user_tournament_detail) ->
      join_game(user_tournament_detail)
    end)
    {:ok, game} = List.last(games)
    %{
      player1: Repo.get(UserTournamentDetail, List.first(utds).id),
      player2: Repo.get(UserTournamentDetail, List.last(utds).id),
      game: game
     }
  end

  def update_scores(game_id) do
    game = Repo.get(Game, game_id)
    UpdateScoresCommand.execute(game)
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

  defp create_user_tournament_details(tournament, players) do
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
      player_id -> game.player2_id
      _ -> game.player1_id
    end
  end

end
