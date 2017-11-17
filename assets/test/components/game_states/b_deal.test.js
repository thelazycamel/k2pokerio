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
      best_cards: [],
      cards: ["Kc","2h"],
      hand_description: "",
      other_player_status: "ready",
      player_status: "new",
      result: {
        lose_description: "",
        other_player_cards: [],
        player_cards: ["Kc", "2d"],
        status: "in_play",
        table_cards: [],
        win_description: "",
        winning_cards: []
      },
      status: "deal",
      table_cards: []
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

describe("Game States: Deal", () => {

  test('The play button should display "Play"', () => {
    expect(gameComponent.find("#play-button").text()).toEqual("Play");
  });

  test('The game status should be waiting for player to play', () => {
    expect(gameComponent.find("#game-status").text()).toEqual("Waiting for you to play");
  });

  test('it should show player card 1', () => {
    expect(gameComponent.find("#player-cards div.card.player-card.card-Kc").length).toEqual(1);
  });

  test('it should show player card 2', () => {
    expect(gameComponent.find("#player-cards div.card.player-card.card-2h").length).toEqual(1);
  });

  test('it should not have locked class to player 1 cards', () => {
    expect(gameComponent.find("#player-cards div.card.locked").length).toEqual(0);
  });


});
