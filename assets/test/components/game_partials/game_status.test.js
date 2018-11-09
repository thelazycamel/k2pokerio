import React from 'react';
import {mount} from 'enzyme';
import configureStore from 'redux-mock-store'
import MockApp from '../../support/mock_app';
import GameStatusComponent from '../../../js/components/game_partials/game_status_component';

const mockStore = configureStore();

describe("Game Status Component", () => {

  beforeEach(() => {
    window.App = MockApp;
    App.t("started"); //fix weird bug where needs a call to App.t before its called in the component
  });

  it("should be on standby", () => {
    let gameStatusComponent = mount(<GameStatusComponent
                                      waiting={true}
                                      finished={false}
                                      game_status="standby"
                                      player_status="new" />)
    expect(gameStatusComponent.find("#game-status").text()).toEqual("Searching for opponents")
  });

  it("should show players status", () => {
    let gameStatusComponent = mount(<GameStatusComponent waiting={false} finished={false} game_status="deal" player_status="new" />)
    expect(gameStatusComponent.find("#game-status").text()).toEqual("Waiting for you to play")
  });

  it("should show win status", () => {
    let gameStatusComponent = mount(<GameStatusComponent waiting={false} finished={true} game_status="finished" player_status="win" />)
    expect(gameStatusComponent.find("#game-status .win-status").text()).toEqual("WIN")
  });

});
