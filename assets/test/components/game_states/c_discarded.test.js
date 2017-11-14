import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import GameComponent from '../../../js/components/game_component';

const mockStore = configureStore();
let store, gameComponent;

beforeEach(() => {

  window.App = {
    settings: {
      page: "gamePlay",
      logged_in: "true",
      tournament_id: 1,
      bots: "true"
    }
  };

  let initialState = {
    page: {tabs: {}, links: {}},
    game: {
      best_cards: [],
      cards: ["Kc","Kh"],
      hand_description: "",
      other_player_status: "ready",
      player_status: "discarded",
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

describe("Game States: Discarded", () => {

  test('The play button should display "Play"', () => {
    expect(gameComponent.find("#play-button").text()).toEqual("Play");
  });

  test('The game status should be standby', () => {
    expect(gameComponent.find("#game-status").text()).toEqual("Discarded, press play");
  });

  test('it should add locked class to player 1 cards', () => {
    expect(gameComponent.find("#player-cards div.card.locked").length).toEqual(2);
  });

});
