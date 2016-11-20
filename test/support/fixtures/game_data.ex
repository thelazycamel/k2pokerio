defmodule K2pokerIo.Fixtures.GameDataFixture do

  def player_wins(player_id) do
    %K2poker.Game{
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

  end

  def player_loses(player_id) do

  end

  def players_draw do

  end


end
