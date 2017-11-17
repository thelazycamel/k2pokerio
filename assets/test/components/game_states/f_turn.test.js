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
      hand_description: "three_of_a_kind",
      other_player_status: "new",
      player_status: "new",
      status: "turn",
      table_cards: ["2c","3s","4h","Kd"],
      result: {
        lose_description: "",
        other_player_cards: [],
        player_cards: [],
        status: "",
        table_cards: [],
        win_description: "",
        winning_cards: []
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

describe("Game States: The Turn", () => {

  test('The play button should display Play', () => {
    expect(gameComponent.find("#play-button").text()).toEqual("Play");
  });

  test('The game status should be standby', () => {
    expect(gameComponent.find("#game-status").text()).toEqual("Waiting for you to play");
  });

  test('The best hand show show a status', () => {
    expect(gameComponent.find("#best-hand").text()).toMatch("Three of a Kind");
  });

  test('The #table-cards should contain 4 cards', () => {
    expect(gameComponent.find("#table-cards .card").length).toEqual(4);
    expect(gameComponent.find("#table-cards .card-2c").length).toEqual(1);
    expect(gameComponent.find("#table-cards .card-3s").length).toEqual(1);
    expect(gameComponent.find("#table-cards .card-4h").length).toEqual(1);
    expect(gameComponent.find("#table-cards .card-Kd").length).toEqual(1);
  });

});
