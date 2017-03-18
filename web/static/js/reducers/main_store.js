// Main Redux Store

import { createStore, combineReducers } from 'redux'
import gameReducer from "./game_reducer"
import tournamentReducer from "./tournament_reducer"
import playerReducer from "./player_reducer"
import pageReducer from "./page_reducer"

var mainStore = combineReducers({
    game: gameReducer,
    tournament: tournamentReducer,
    player: playerReducer,
    page: pageReducer
});

export default mainStore;
