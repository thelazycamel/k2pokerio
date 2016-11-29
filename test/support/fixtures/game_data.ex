defmodule K2pokerIo.Fixtures.GameDataFixture do

  alias K2pokerIo.Repo
  alias K2pokerIo.Game

  # #player_wins -> create winning game_data for player1
  # overwrite the game_data for the given Game and player_id
  # returns the updated Game
  #
  def player_wins(game, player_id) do
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player_id, cards: ["As", "Ac"], status: "new"},
        %K2poker.Player{id: "other_player", cards: ["2s", "3c"], status: "new"}
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

  # #player_loses -> create losing game_data for player1
  # overwrite the game_data for the given Game and player_id
  # returns the updated Game
  #
  def player_loses(game, player_id) do
    game_data = %K2poker.Game{
     players: [
        %K2poker.Player{id: player_id, cards: ["2s", "3c"], status: "new"},
        %K2poker.Player{id: "other_player", cards: ["Ac", "As"], status: "new"}
      ],
      table_cards: ["Ad", "Ah", "3d", "2c", "4h"],
      status: "finished",
      deck: [],
      result: %K2poker.GameResult{
        player_id: "other_player",
        status: "win",
        cards: ["As", "Ac", "Ad", "Ah", "4h"],
        win_description: "four_of_a_kind",
        lose_description: "two_pair"
      }
    }
    return_updated_game(game, game_data)
  end

  # #playes_draw -> create losing game_data for player1
  # overwrite the game_data for the given Game
  # returns the updated Game
  #
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

  def player_folds(game, player_id) do
    decoded_game_data = Game.decode_game_data(game.data)
    game_data = K2poker.fold(decoded_game_data, player_id)
    return_updated_game(game, game_data)
  end

  defp return_updated_game(game, game_data) do
    encoded_game_data = Poison.encode!(game_data)
    changeset = Game.changeset(game, %{data: encoded_game_data})
    {:ok, game} = Repo.update(changeset)
    game
  end


end
