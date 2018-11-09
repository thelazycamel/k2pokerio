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
      player_status: "win",
      status: "finished",
      table_cards: ["2c","3s","4h","Kd","Ks"],
      result: {
        lose_description: "pair",
        other_player_cards: ["8d","6c"],
        player_cards: ["Kc", "Kh"],
        status: "win",
        table_cards: ["2c","3s","4h","Kd","Ks"],
        win_description: "four_of_a_kind",
        winning_cards: ["Kc","Kh","Kd","Ks","4h"]
      }
    },
    player: {
      current_score: 2,
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
    expect(gameComponent.find("#game-status").text()).toEqual("WIN");
  });

  test('The best hand show show a status', () => {
    expect(gameComponent.find("#best-hand").text()).toMatch("Four of a Kind");
  });

  test('The winning cards should have the winning class', () => {
    expect(gameComponent.find(".card-Kh.winner").length).toEqual(1);
    expect(gameComponent.find(".card-Kc.winner").length).toEqual(1);
    expect(gameComponent.find(".card-Kd.winner").length).toEqual(1);
    expect(gameComponent.find(".card-Ks.winner").length).toEqual(1);
    expect(gameComponent.find(".card-4h.winner").length).toEqual(1);
  });

});
