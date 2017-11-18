import React from "react"
import ReactDOM from "react-dom"

class GameStatusComponent extends React.Component {

  winLoseStatus(){
   return(
     <span className={`${this.props.player_status}-status`}>
      You {App.t(this.props.player_status)}
     </span>
   );
  }

  currentStatus(){
    let status = this.props.waiting ? this.props.game_status : this.props.player_status;
    return(App.t(`status_${status}`));
  }

  render() {
    return(
      <div id="game-status">
        {this.props.finished ? this.winLoseStatus() : this.currentStatus()}
      </div>
    )
  }

}

export default GameStatusComponent;
