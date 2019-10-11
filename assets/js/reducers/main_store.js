// Main Redux Store

import { createStore, combineReducers } from 'redux'
import gameReducer from "reducers/game_reducer"
import tournamentReducer from "reducers/tournament_reducer"
import playerReducer from "reducers/player_reducer"
import pageReducer from "reducers/page_reducer"
import chatReducer from "reducers/chat_reducer"
import opponentProfileReducer from "reducers/opponent_profile_reducer"

var mainStore = combineReducers({
    game: gameReducer,
    tournament: tournamentReducer,
    player: playerReducer,
    chat: chatReducer,
    page: pageReducer,
    opponent_profile: opponentProfileReducer
});

export default mainStore;
