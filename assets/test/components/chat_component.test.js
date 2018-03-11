import React from 'react';
import {mount} from 'enzyme';
import configureStore from 'redux-mock-store'
import MockApp from '../support/mock_app';
import ChatComponent from '../../js/components/chat_component';

const mockStore = configureStore();
let store, chatComponent;

beforeEach(() => {

  window.App = MockApp;
  window.App.settings.logged_in = "false";

  let initialState = {
    page: {tabs: {}, links: {}},
    chat: {comments: [
      {id: 1, username: "bob", image: "/profile-images/test.png", comment: "Hello World"}
   ]},
    tournament: {}
  };

 store = mockStore(initialState)
 chatComponent = mount( <ChatComponent store={store} />);

});

describe("ChatComponent", () => {

  it("should contain the div#chats holder", () => {
    expect(chatComponent.find("div#chats").length).toEqual(1);
  });

  it('should contain one comment', () => {
    expect(chatComponent.find("div.chat-comment").length).toEqual(1);
    expect(chatComponent.find("div.chat-comment").html()).toMatch(/chat-user.*bob.*chat-text.*Hello\ World/);
  });

  test("#renderInput() should be disabled for logged out users", () => {
    expect(chatComponent.find("#new-chat").html()).toMatch(/Log.in.to.join.the.conversation.*disabled/);
  });

  test("#renderInput() should be enabled for logged in users", () => {
    window.App.settings.logged_in = "true";
    let initialState = {
      page: {tabs: {}, links: {}},
      chat: {comments: [{id: 1, username: "bob", comment: "Hello World"}]},
      tournament: {}
    };
    store = mockStore(initialState)
    chatComponent = mount( <ChatComponent store={store} />);
    expect(chatComponent.find("#new-chat").html()).toMatch(/\<input\ type="text"\ class="logged-in"\ id="new-chat"\>/);
  });

});

