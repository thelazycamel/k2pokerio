import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import GameStatusComponent from '../../../js/components/game/game_status_component';

const mockStore = configureStore();
let store, gameComponent;

describe("Game Status", () => {

  it("should do something", () => {
    expect(true).toBe(true);
  });

});
