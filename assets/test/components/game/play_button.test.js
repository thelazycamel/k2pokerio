import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import PlayButtonComponent from '../../../js/components/game/play_button_component';

const mockStore = configureStore();
let store, gameComponent;

describe("Play Button", () => {

  it("should do something", () => {
    expect(true).toBe(true);
  });

});
