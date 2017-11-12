import React from 'react';
import {shallow, mount, render} from 'enzyme';
import configureStore from 'redux-mock-store'
import ChatComponent from '../../js/components/chat_component';

const mockStore = configureStore();
let store, chatComponent;

beforeEach(() => {

  window.App = {
    settings: {
      logged_in: false,
      tournament_id: 1
    }
  };

  let initialState = {
    page: {tabs: {}, links: {}},
    chat: {comments: [
      {id: 1, username: "bob", comment: "Hello World"}
   ]},
    tournament: {}
  };

 store = mockStore(initialState)
 chatComponent = mount( <ChatComponent store={store} />);

});

describe("ChatComponent", () => {

  it("should contain the chats ul holder", () => {
    expect(chatComponent.find("ul#chats").length).toEqual(1);
  });

  it('should contain one comment', () => {
    expect(chatComponent.find("li.chat-comment").length).toEqual(1);
    expect(chatComponent.find("li.chat-comment").html()).toMatch(/chat-user.*bob.*chat-text.*Hello\ World/);
  });

  test("#renderInput() should be disabled for logged out users", () => {
    expect(chatComponent.find("#new-chat").html()).toMatch(/Log.in.to.join.the.conversation.*disabled/);
  });

});

