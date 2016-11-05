// Main Redux Store, combines gameReducers and tournamentReducers

import { createStore, combineReducers } from 'redux'
import gameReducer from "./game_reducer"
import tournamentReducer from "./tournament_reducer"

var mainStore = combineReducers({
    game: gameReducer,
    tournament: tournamentReducer
});

export default mainStore;
