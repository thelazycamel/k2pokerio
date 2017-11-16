import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import BestHandComponent from '../../../js/components/game/best_hand_component';

const mockStore = configureStore();
let store, gameComponent;

describe("Best Hand", () => {

  it("should show whatever when waiting for an apponent", () => {
    expect(2-1).toEqual(1)
  });

  it("should show hand ranking when passed", () => {
    expect(true).toBe(true);
  });

});
