class Utils {

  percentage(played, wins){
    if(wins == 0 || played == 0) {
      return "-";
    } else {
      let percent = wins / played * 100;
      percent = Math.round(percent * 100) / 100;
      return `${percent}%`;
    }
  }

}

export default Utils;
