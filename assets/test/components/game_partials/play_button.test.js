import React from 'react';
import {mount} from 'enzyme';
import configureStore from 'redux-mock-store'
import PlayButtonComponent from '../../../js/components/game_partials/play_button_component';
import MockApp from '../../support/mock_app';
const mockStore = configureStore();
let store, playButtonComponent;

describe("Play Button", () => {

  beforeEach( () => {
    window.App = MockApp;
    App.t("started"); //fix weird bug where needs a call to App.t before its called in the component

  });

  it("should show 'searching...' whist searching for opponents (game with bots)", () => {
    let state = {
      page: {tabs: {}, links: {}},
      game: {
        best_cards: [],
        cards: [],
        hand_description: "",
        other_player_status: "",
        player_status: "new",
        result: {
          lose_description: "",
          other_player_cards: [],
          player_cards: [],
          status: "standby",
          table_cards: [],
          win_description: "",
          winning_cards: []
        },
        status: "standby",
        table_cards: []
      },
      player: {
        current_score: 1,
        username: "stu"
      },
      opponent_profile: {}
    }

    App.settings.bots = "true";
    let playButtonComponent = mount(<PlayButtonComponent store={mockStore(state)} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Searching...");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(1);
  });

  it("should show 'Next Game' when finished", () => {
    let state = {
      page: {tabs: {}, links: {}},
      game: {
        best_cards: [],
        cards: [],
        hand_description: "",
        other_player_status: "",
        player_status: "new",
        result: {
          lose_description: "",
          other_player_cards: [],
          player_cards: [],
          status: "finished",
          table_cards: [],
          win_description: "",
          winning_cards: []
        },
        status: "finished",
        table_cards: []
      },
      player: {
        current_score: 1,
        username: "stu"
      },
      opponent_profile: {}
    }

    let playButtonComponent = mount(<PlayButtonComponent store={mockStore(state)} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Next Game");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(0);
  });

  it("should show 'Waiting...' when waiting for opponent to play", () => {
    let state = {
      page: {tabs: {}, links: {}},
      game: {
        best_cards: [],
        cards: [],
        hand_description: "",
        other_player_status: "new",
        player_status: "ready",
        result: {
          lose_description: "",
          other_player_cards: [],
          player_cards: [],
          status: "deal",
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
    }

    let playButtonComponent = mount(<PlayButtonComponent store={mockStore(state)} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Waiting...");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(1);
  });

  it("should show 'Waiting...' when waiting for opponent in a game with no bots", () => {
    let state = {
      page: {tabs: {}, links: {}},
      game: {
        best_cards: [],
        cards: [],
        hand_description: "",
        other_player_status: "",
        player_status: "ready",
        result: {
          lose_description: "",
          other_player_cards: [],
          player_cards: [],
          status: "standby",
          table_cards: [],
          win_description: "",
          winning_cards: []
        },
        status: "standby",
        table_cards: []
      },
      player: {
        current_score: 1,
        username: "stu"
      },
      opponent_profile: {}
    }

    App.settings.bots = "false";
    let playButtonComponent = mount(<PlayButtonComponent store={mockStore(state)} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Waiting...");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(1);
  });

  it("should 'Play' when the player can play", () => {
    let state = {
      page: {tabs: {}, links: {}},
      game: {
        best_cards: [],
        cards: [],
        hand_description: "",
        other_player_status: "new",
        player_status: "new",
        result: {
          lose_description: "",
          other_player_cards: [],
          player_cards: [],
          status: "flop",
          table_cards: [],
          win_description: "",
          winning_cards: []
        },
        status: "flop",
        table_cards: []
      },
      player: {
        current_score: 1,
        username: "stu"
      },
      opponent_profile: {}
    }

    let playButtonComponent = mount(<PlayButtonComponent store={mockStore(state)} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Play");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(0);
  });

  it("should show 'Play Bot?' when requested", () => {
    let state = {
      page: {tabs: {}, links: {}},
      game: {
        show_bot_request: true,
        best_cards: [],
        cards: [],
        hand_description: "",
        other_player_status: "new",
        player_status: "ready",
        result: {
          lose_description: "",
          other_player_cards: [],
          player_cards: [],
          status: "standby",
          table_cards: [],
          win_description: "",
          winning_cards: []
        },
        status: "standby",
        table_cards: []
      },
      player: {
        current_score: 1,
        username: "stu"
      },
      opponent_profile: {},
    }

    App.settings.bots = "true";
    let playButtonComponent = mount(<PlayButtonComponent store={mockStore(state)} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Play Bot?");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(0);
    expect(playButtonComponent.find("#play-button.bot-request").length).toEqual(1);
  });

});
