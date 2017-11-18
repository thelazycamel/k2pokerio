import React from 'react';
import {render} from 'enzyme';
import configureStore from 'redux-mock-store'
import CardComponent from '../../../js/components/game_components/card_component';

const mockStore = configureStore();

describe("Card Component", () => {

  it("should be a oppenent card back", () => {
    let cardComponent = render(
      <CardComponent
        card="back"
        index={1}
        best_card={false}
        type="opponent"
        key={1}
        winner={false} />
    );
    expect(cardComponent.find(".opponent-card").length).toEqual(1);
    expect(cardComponent.find(".card-back").length).toEqual(1);
  });

  it("should be a table card Kc with an index of 0", () => {
    let cardComponent = render(
      <CardComponent
        card="Kc"
        index={0}
        best_card={false}
        type="table"
        key={1}
        winner={false} />
    );
    expect(cardComponent.find(".table-card").length).toEqual(1);
    expect(cardComponent.find(".card-Kc").length).toEqual(1);
    expect(cardComponent.find(".card[data-card='0']").length).toEqual(1);
  });

  it("should be one of the players best hand", () => {
    let cardComponent = render(
      <CardComponent
        card="Kc"
        index={0}
        best_card={true}
        type="table"
        key={1}
        winner={false} />
    );
    expect(cardComponent.find(".best-card").length).toEqual(1);
  });

});
