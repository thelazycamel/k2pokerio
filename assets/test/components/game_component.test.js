import React from 'react';
import {mount} from 'enzyme';
import configureStore from 'redux-mock-store'
import MockApp from '../support/mock_app';
import GameComponent from '../../js/components/game_component';

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
    opponent_profile: {
      blurb: "I am a test user",
      friend: "na",
      id: null,
      image: "bender.png",
      opponent: "bot",
      username: "TestingBot"
    }
  }

  store = mockStore(initialState);
  gameComponent = mount( <GameComponent store={store} />);

});

test('it should have a profile image', () => {
  let expected = "<a id=\"opponent-image\"><img src=\"/images/profile-images/bender.png\" alt=\"TestingBot\"><div id=\"opponent-name\">TestingBot</div></a>";
  expect(gameComponent.find("#opponent-image").html()).toEqual(expected);
});

test('it should have a fold button', () => {
  expect(gameComponent.find("#fold-button").length).toEqual(1);
});

test('it should have a play button', () => {
  expect(gameComponent.find("#play-button").length).toEqual(1);
});

test('it should show back of opponent cards', () => {
  expect(gameComponent.find(".card.opponent-card.card-back").length).toEqual(2);
});

test('it should show player card 1', () => {
  expect(gameComponent.find("#player-cards div.card.player-card.card-Kc").length).toEqual(1);
});

test('it should show player card 2', () => {
  expect(gameComponent.find("#player-cards div.card.player-card.card-2h").length).toEqual(1);
});

test('it should hold the scoreboard', () => {
  expect(gameComponent.find(".scoreboard .scoreboard-inner .ani-num-8.number-1").length).toEqual(1);
});
