import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import MockApp from '../../support/mock_app';
import GameComponent from '../../../js/components/game_component';

const mockStore = configureStore();
let store, gameComponent;

beforeEach(() => {

  window.App = MockApp;

  let initialState = {
    page: {tabs: {}, links: {}},
    game: {
      best_cards: ["Kc", "Kh", "Kd", "3s", "4h"],
      cards: ["Kc","Kh"],
      hand_description: "four_of_a_kind",
      other_player_status: "lose",
      player_status: "lose",
      status: "finished",
      table_cards: ["2s","3s","4s","Kd","Ks"],
      result: {
        lose_description: "four_of_a_kind",
        other_player_cards: ["5s","6s"],
        player_cards: ["Kc", "Kh"],
        status: "lose",
        table_cards: ["2c","3s","4h","Kd","Ks"],
        win_description: "straight_flush",
        winning_cards: ["2s","3s","4s","5s","6s"]
      }
    },
    player: {
      current_score: 1,
      username: "stu"
    },
    opponent_profile: {}
  };

  store = mockStore(initialState);
  gameComponent = mount( <GameComponent store={store} />);
});

describe("Game States: Player wins", () => {

  test('The play button should display Next Game', () => {
    expect(gameComponent.find("#play-button").text()).toEqual("Next Game");
  });

  test('The game status should be "You Win"', () => {
    expect(gameComponent.find("#game-status").text()).toEqual("You Lose");
  });

  test('The best hand show show a status', () => {
    expect(gameComponent.find("#best-hand").text()).toMatch("Straight Flush");
  });

  test('The winning cards should have the winning class', () => {
    expect(gameComponent.find(".card-2s.winner").length).toEqual(1);
    expect(gameComponent.find(".card-3s.winner").length).toEqual(1);
    expect(gameComponent.find(".card-4s.winner").length).toEqual(1);
    expect(gameComponent.find(".card-5s.winner").length).toEqual(1);
    expect(gameComponent.find(".card-6s.winner").length).toEqual(1);
  });

});
