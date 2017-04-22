// Main Redux Store

import { createStore, combineReducers } from 'redux'
import gameReducer from "./game_reducer"
import tournamentReducer from "./tournament_reducer"
import playerReducer from "./player_reducer"
import pageReducer from "./page_reducer"
import chatReducer from "./chat_reducer"

var mainStore = combineReducers({
    game: gameReducer,
    tournament: tournamentReducer,
    player: playerReducer,
    chat: chatReducer,
    page: pageReducer
});

export default mainStore;
