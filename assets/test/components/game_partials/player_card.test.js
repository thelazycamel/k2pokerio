import React from 'react';
import {mount} from 'enzyme';
import MockApp from '../../support/mock_app';
import configureStore from 'redux-mock-store'
import PlayerCardComponent from 'components/game_partials/player_card_component';

const mockStore = configureStore();

let playerCard;

describe("Player Card", () => {

  beforeEach( () => {
    window.App = MockApp;
    playerCard = mount(<PlayerCardComponent
                             card="Kc"
                             index={0}
                             best_card={true}
                             key={1}
                             winner={true}
                             status="new" />);
  });

  it("should have a player-card class", () => {
    expect(playerCard.find(".player-card").length).toEqual(1);
  });

  it("should have a card value/suite class", () => {
    expect(playerCard.find(".card-Kc").length).toEqual(1);
  });

  it("should have a best-card class", () => {
    expect(playerCard.find(".best-card").length).toEqual(1);
  });

  it("should have an animation new-card class", () => {
    playerCard.setState({new_card: true});
    expect(playerCard.find(".new-card").length).toEqual(1);
  });

  it("should have a winner class", () => {
    playerCard.setState({new_card: true});
    expect(playerCard.find(".winner").length).toEqual(1);
  });

});
