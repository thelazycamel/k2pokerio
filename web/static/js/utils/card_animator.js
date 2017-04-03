class CardAnimator {

  constructor() {
    this.opponentDiscardState = {deal: false, flop: false, turn: false, river: false};
    this.discardState = {deal: false, flop: false, turn: false, river: false};
  }

  animate(cardId, skipDelay){
    let delay = this._getDelayForCard(cardId, skipDelay);
    let cardStart = this._cardStartPosition();
    let $card = $("#"+cardId);
    $card.removeAttr("style");
    let top = $card.css("top");
    let left = $card.css("left");
    $card.css({top: "-200px", left: cardStart+"px", zIndex: 20});
    setTimeout(function(){
      $card.animate({
        top: top,
        left: left,
        zIndex: 1
      }, 300);
    }, delay);
  }

  discards(gameData){
    if(gameData.player_status == "discarded" && !this.discardState[gameData.status]) {
      this._playerDiscard(gameData);
    }
    if(gameData.other_player_status == "discarded" && !this.opponentDiscardState[gameData.status]) {
      this._opponentDiscard(gameData);
    }
  }

  //PRIVATE

  _playerDiscard(gameData){
    switch(gameData.status){
      case "river":
        this._animateRemoveCard("player-card-1");
        this._animateRemoveCard("player-card-2");
        break;
      default:
        let cardId = $(".player-card.discarded").attr("id");
        if(cardId) {
          this._animateRemoveCard(cardId);
        }
    }
    this.discardState[gameData.status] = true;
  }

  _opponentDiscard(gameData){
    switch(gameData.status){
      case "river":
        this._animateRemoveCard("opponent-card-1");
        this._animateRemoveCard("opponent-card-2");
        break;
      default:
        let card = Math.floor((Math.random() * 2) + 1);
        this._animateRemoveCard("opponent-card-"+card);
    }
    this.opponentDiscardState[gameData.status] = true;
  }

  _animateRemoveCard(cardId){
    let $card = $("#"+cardId);
    let _this = this;
    if($card.length > 0) {
      $card.animate({
        top: "0px",
        zIndex: 10
      }, 200, "swing",
        function(){
          //TODO - this should all be held by some redux state, 
          //i dont link removing it here, perhaps the discarded
          //class can just run a css animation
          //https://medium.com/@joethedave/achieving-ui-animations-with-react-the-right-way-562fa8a91935
          $card.removeClass("discarded");
          _this.animate(cardId, true);
        }
      );
    }
  }

  _cardStartPosition(){
    let page = App.store.getState().page;
    return function() {
      switch(page.screen_size) {
      case "monitor":
        return 275;
        break;
      case "htablet":
        return 225;
        break;
      case "vtablet":
        return 175;
        break;
      case "plablet":
        return 175;
        break;
      case "phone":
        return 125;
        break;
      default:
        return 200;
      }
    }();
  }

  _getDelayForCard(cardId, skipDelay) {
    if(skipDelay) {return 0}
    return function() {
      switch(cardId) {
        case "opponent-card-2":
          return 400;
          break
        case "player-card-1":
          return 200;
          break;
        case "player-card-2":
          return 600;
          break;
        case "table-card-2":
          return 200;
          break;
        case "table-card-3":
          return 400;
          break;
        default:
          return 0;
      }
    }();
  }

}


export default CardAnimator;
