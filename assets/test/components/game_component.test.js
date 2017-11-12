import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import GameComponent from '../../js/components/game_component';

const mockStore = configureStore();
let store, gameComponent;

beforeEach(() => {

  window.App = {
    settings: {
      page: "gamePlay",
      logged_in: true,
      tournament_id: 1,
      bots: true
    }
  };

  let initialState = {
    page: {tabs: {}, links: {}},
    game: {},
    player: {},
    opponent_profile: {}
  };

  store = mockStore(initialState);
  gameComponent = mount( <GameComponent store={store} />);

});

test('does it work?', () => {
  expect(true).toBe(true);
});

test('is false true with not', () => {
  expect(true).not.toBe(false);
});
