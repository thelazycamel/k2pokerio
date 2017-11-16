import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import CardComponent from '../../../js/components/game/card_component';

const mockStore = configureStore();
let store, gameComponent;

describe("Card", () => {

  it("should do something", () => {
    expect(true).toBe(true);
  });

});
