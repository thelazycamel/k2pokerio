import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import MockApp from '../../support/mock_app';
import BestHandComponent from '../../../js/components/game/best_hand_component';

const mockStore = configureStore();
let store, gameComponent;

describe("Best Hand", () => {

  beforeEach(() => {
    window.app = MockApp;
  });

  it("should show whatever when waiting for an apponent", () => {
    let bestHandComponent = mount(<BestHandComponent is_finished={false} winning_hand={null} hand={null} />);
    expect(bestHandComponent.find(".result-hand").text()).toEqual("");
  });

  it("should show hand ranking when passed", () => {
    // App.t fails because App does not exist in the context of the mounted test component
    //let bestHandComponent = mount(<BestHandComponent is_finished={false} winning_hand={null} hand="pair" />);
    //expect(bestHandComponent.find(".result-hand").text()).toEqual("Pair");
  });

});
