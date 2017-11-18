import React from 'react';
import {mount} from 'enzyme';
import configureStore from 'redux-mock-store'
import MockApp from '../../support/mock_app';
import BestHandComponent from '../../../js/components/game_components/best_hand_component';

const mockStore = configureStore();

describe("Best Hand", () => {

  beforeEach(() => {
    window.App = MockApp;
  });

  it("should show whatever when waiting for an apponent", () => {
    let bestHandComponent = mount(<BestHandComponent is_finished={false} winning_hand={null} hand={null} />);
    expect(bestHandComponent.find(".result-hand").text()).toEqual("");
  });

  it("should show hand ranking when passed", () => {
    let bestHandComponent = mount(<BestHandComponent is_finished={false} winning_hand={null} hand="one_pair" />);
    expect(bestHandComponent.find(".result-hand").text()).toEqual("One Pair");
  });

  it("should show winning hand  when passed finished", () => {
    let bestHandComponent = mount(<BestHandComponent is_finished={true} winning_hand="flush" hand="one_pair" />);
    expect(bestHandComponent.find(".result-hand").text()).toEqual("Flush");
  });

});
