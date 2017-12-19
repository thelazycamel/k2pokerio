import React from 'react';
import {mount} from 'enzyme';
import configureStore from 'redux-mock-store'
import PlayButtonComponent from '../../../js/components/game_components/play_button_component';
import MockApp from '../../support/mock_app';
const mockStore = configureStore();
let store, playButtonComponent;

describe("Play Button", () => {

  beforeEach( () => {
    window.App = MockApp;
    App.t("started"); //fix weird bug where needs a call to App.t before its called in the component

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
  });

  it("should show 'searching...' whist waiting for opponents", () => {
    let playButtonComponent = mount(<PlayButtonComponent waiting={true} finished={false} opponent_turn={false} store={store} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Searching...");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(1);
  });

  it("should show 'Next Game' when finished", () => {
    let playButtonComponent = mount(<PlayButtonComponent waiting={false} finished={true} opponent_turn={false} store={store} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Next Game");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(0);
  });

  it("should show 'Waiting...' when waiting for opponent to play", () => {
    let playButtonComponent = mount(<PlayButtonComponent waiting={false} finished={false} opponent_turn={true} store={store} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Waiting...");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(1);
  });

  it("should show 'Waiting...' when waiting for opponent in a game with no bots", () => {
    App.settings.bots = "false";
    let playButtonComponent = mount(<PlayButtonComponent waiting={true} finished={false} opponent_turn={false} store={store} />)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Waiting...");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(1);
  });

  it("should 'Play' when the player can play", () => {
    let playButtonComponent = mount(<PlayButtonComponent waiting={false} finished={false} opponent_turn={false} store={store}/>)
    expect(playButtonComponent.find("#play-button").text()).toEqual("Play");
    expect(playButtonComponent.find("#play-button.waiting").length).toEqual(0);
  });

});
