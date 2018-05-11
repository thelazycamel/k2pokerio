import React from 'react';
import {mount} from 'enzyme';
import MockApp from '../../support/mock_app';
import configureStore from 'redux-mock-store'
import OpponentProfileImageComponent from '../../../js/components/game_components/opponent_profile_image_component';

const mockStore = configureStore();

let opponentProfileImageComponent;

describe("Opponent Profile Image", () => {

  beforeEach( () => {
    window.App = MockApp;
    let opponentProfile = {image: "/images/profile-images/test.png", username: "Test User"};
    opponentProfileImageComponent = mount(<OpponentProfileImageComponent opponent_profile={opponentProfile}/>);
  });

  it("should have an image and username", () => {
    let expected = "<a id=\"opponent-image\"><img src=\"/images/profile-images/test.png\" alt=\"Test User\"><div id=\"opponent-name\">Test User</div></a>";
    expect(opponentProfileImageComponent.find("#opponent-image").html()).toEqual(expected);
  });

});
