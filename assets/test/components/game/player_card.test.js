import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import PlayerCardComponent from '../../../js/components/game/player_card_component';

const mockStore = configureStore();
let store, gameComponent;

describe("Player Card", () => {

  it("should do something", () => {
    expect(true).toBe(true);
  });

});
