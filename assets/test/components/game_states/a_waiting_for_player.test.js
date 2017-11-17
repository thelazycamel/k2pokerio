import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store';
import MockApp from '../../support/mock_app';
import GameComponent from '../../../js/components/game_component';

const mockStore = configureStore();
let store, gameComponent;

beforeEach(() => {

  window.App = MockApp;

  let initialState = {
    page: {tabs: {}, links: {}},
    game: {
      status: "standby",
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

describe("Game States: Waiting for a player", () => {

  test('The play button should display "Searching..."', () => {
    expect(gameComponent.find("#play-button").text()).toEqual("Searching...");
  });

  test('The game status should be standby', () => {
    expect(gameComponent.find("#game-status").text()).toEqual("standby");
  });

});
